import io
import os
import threading
import time
import uuid
from collections import deque
from datetime import datetime, timedelta

import cv2
import joblib
from fastapi import FastAPI, File, HTTPException, Query, UploadFile
from fastapi.responses import StreamingResponse
from fastapi.staticfiles import StaticFiles
from PIL import Image
from pydantic import BaseModel
from ultralytics import YOLO

app = FastAPI()

# CCTV 탐지 로그용 스냅샷 이미지 저장 폴더. /cctv/logs/파일명 으로 접근 가능.
CCTV_LOG_DIR = "cctv_logs"
os.makedirs(CCTV_LOG_DIR, exist_ok=True)
app.mount("/cctv/logs", StaticFiles(directory=CCTV_LOG_DIR), name="cctv_logs")

helmet_model = YOLO("best.pt")

# risk_model.pkl은 {"model": ..., "features": [...], "labels": [...]} 형태의 딕셔너리로 저장되어 있음
_risk_bundle = joblib.load("risk_model.pkl")
risk_model = _risk_bundle["model"]

# ── 안전모 탐지 ──────────────────────────────────────────────
# 로보플로우 클래스 체계: helmet(착용) / head(미착용) / person(참고용, 판정에 미사용)
HELMET_LABEL = "helmet"
NO_HELMET_LABEL = "head"
CONFIDENCE_THRESHOLD = 0.7


def run_helmet_detection(image):
    results = helmet_model.predict(image, conf=CONFIDENCE_THRESHOLD, verbose=False)
    names = helmet_model.names
    predictions = []
    for box in results[0].boxes:
        label = str(names[int(box.cls)]).lower()
        confidence = float(box.conf)
        x, y, w, h = [float(v) for v in box.xywh[0]]
        predictions.append({
            "class": label,
            "confidence": round(confidence, 4),
            "x": x, "y": y, "width": w, "height": h,
        })

    helmet_count = sum(1 for p in predictions if p["class"] == HELMET_LABEL)
    no_helmet_count = sum(1 for p in predictions if p["class"] == NO_HELMET_LABEL)

    if no_helmet_count > 0:
        status = "violation"
        helmet_worn = False
        message = f"안전모 미착용자 {no_helmet_count}명이 감지되었습니다."
    elif helmet_count > 0:
        status = "pass"
        helmet_worn = True
        message = "전원 안전모를 착용했습니다."
    else:
        return {"success": False, "status": "undetermined", "predictions": predictions,
                "message": "안전모/머리를 검출하지 못했습니다."}

    return {
        "success": True,
        "status": status,
        "helmetWorn": helmet_worn,
        "helmetCount": helmet_count,
        "noHelmetCount": no_helmet_count,
        "message": message,
        "predictions": predictions,
    }


@app.post("/helmet/predict")
async def predict_helmet(file: UploadFile = File(...)):
    image_bytes = await file.read()
    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    return run_helmet_detection(image)


# ── CCTV 실시간 프레임 탐지 ───────────────────────────────────
CAPTURE_INTERVAL_SECONDS = 15
MAX_JOB_DURATION = timedelta(hours=6)  # 방치된 작업 자동 종료용 안전장치
ALLOWED_SCHEMES = ("rtsp://", "http://", "https://")


class CctvJob:
    def __init__(self, rtsp_url: str):
        self.rtsp_url = rtsp_url
        self.started_at = datetime.now()
        self.stop_event = threading.Event()
        self.thread = threading.Thread(target=self._run, daemon=True)
        self.last_result = None
        self.last_checked_at = None
        self.error = None
        self.latest_frame = None
        self.last_predictions = []
        self.frame_lock = threading.Lock()
        self.history = deque(maxlen=100)  # 최근 탐지 로그 (화면에 착용/미착용 이력으로 표시)

    def start(self):
        self.thread.start()

    def stop(self):
        self.stop_event.set()

    def _run(self):
        capture = cv2.VideoCapture(self.rtsp_url)
        if not capture.isOpened():
            self.error = "카메라 스트림을 열 수 없습니다."
            self.stop_event.set()
            return

        last_detect_at = 0.0
        try:
            while not self.stop_event.is_set():
                if datetime.now() - self.started_at > MAX_JOB_DURATION:
                    self.error = "최대 실행 시간을 초과해 자동 종료되었습니다."
                    break

                ok, frame = capture.read()
                if not ok:
                    self.error = "프레임을 읽을 수 없습니다."
                    break

                with self.frame_lock:
                    self.latest_frame = frame

                now = time.monotonic()
                if now - last_detect_at >= CAPTURE_INTERVAL_SECONDS:
                    image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                    self.last_result = run_helmet_detection(image)
                    self.last_predictions = self.last_result.get("predictions", [])
                    self.last_checked_at = datetime.now().isoformat()

                    snapshot_frame = _draw_predictions(frame, self.last_predictions)
                    filename = f"{datetime.now().strftime('%Y%m%d_%H%M%S')}_{uuid.uuid4().hex[:8]}.jpg"
                    cv2.imwrite(os.path.join(CCTV_LOG_DIR, filename), snapshot_frame)

                    if len(self.history) == self.history.maxlen:
                        oldest = self.history[-1]
                        old_path = os.path.join(CCTV_LOG_DIR, os.path.basename(oldest.get("image", "")))
                        if oldest.get("image") and os.path.exists(old_path):
                            os.remove(old_path)

                    self.history.appendleft({
                        "checkedAt": self.last_checked_at,
                        "status": self.last_result.get("status"),
                        "helmetWorn": self.last_result.get("helmetWorn"),
                        "message": self.last_result.get("message"),
                        "image": f"/cctv/logs/{filename}",
                    })
                    last_detect_at = now
        finally:
            capture.release()

    def get_frame_jpeg(self):
        # 실시간 영상은 매 프레임 갱신되는데 탐지 박스는 15초에 한 번만 갱신되어 움직이는 사람을
        # 따라가지 못하고 어긋나 보이므로, 박스는 로그 스냅샷에서만 보여주고 실시간 영상은 그대로 내보낸다.
        with self.frame_lock:
            frame = self.latest_frame
        if frame is None:
            return None

        ok, buffer = cv2.imencode(".jpg", frame)
        return buffer.tobytes() if ok else None


def _draw_predictions(frame, predictions):
    frame = frame.copy()
    for p in predictions:
        is_helmet = p["class"] == HELMET_LABEL
        color = (0, 200, 0) if is_helmet else (0, 0, 230)  # BGR: 초록=착용, 빨강=미착용
        x1 = int(p["x"] - p["width"] / 2)
        y1 = int(p["y"] - p["height"] / 2)
        x2 = int(p["x"] + p["width"] / 2)
        y2 = int(p["y"] + p["height"] / 2)
        cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
        label = f"{'helmet' if is_helmet else 'head'} {p['confidence']:.2f}"
        (tw, th), _ = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.5, 1)
        cv2.rectangle(frame, (x1, y1 - th - 8), (x1 + tw + 6, y1), color, -1)
        cv2.putText(frame, label, (x1 + 3, y1 - 5), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)
    return frame


_cctv_job: CctvJob | None = None
_cctv_lock = threading.Lock()


@app.post("/cctv/start")
async def start_cctv(rtsp_url: str = Query(...)):
    global _cctv_job

    if not rtsp_url.startswith(ALLOWED_SCHEMES):
        raise HTTPException(status_code=400, detail="지원하지 않는 스트림 주소 형식입니다.")

    with _cctv_lock:
        if _cctv_job is not None and _cctv_job.thread.is_alive():
            raise HTTPException(status_code=409, detail="이미 진행 중인 CCTV 탐지가 있습니다. 먼저 중지해 주세요.")
        _cctv_job = CctvJob(rtsp_url)
        _cctv_job.start()

    return {"success": True, "message": "CCTV 탐지를 시작했습니다.", "intervalSeconds": CAPTURE_INTERVAL_SECONDS}


@app.post("/cctv/stop")
async def stop_cctv():
    global _cctv_job

    with _cctv_lock:
        if _cctv_job is None or not _cctv_job.thread.is_alive():
            raise HTTPException(status_code=409, detail="진행 중인 CCTV 탐지가 없습니다.")
        _cctv_job.stop()

    return {"success": True, "message": "CCTV 탐지를 중지했습니다."}


def _mjpeg_frames(job: CctvJob):
    while not job.stop_event.is_set():
        jpeg = job.get_frame_jpeg()
        if jpeg is not None:
            yield b"--frame\r\nContent-Type: image/jpeg\r\n\r\n" + jpeg + b"\r\n"
        time.sleep(0.1)


@app.get("/cctv/stream")
async def cctv_stream():
    with _cctv_lock:
        job = _cctv_job

    if job is None or not job.thread.is_alive():
        raise HTTPException(status_code=409, detail="진행 중인 CCTV 탐지가 없습니다.")

    return StreamingResponse(_mjpeg_frames(job), media_type="multipart/x-mixed-replace; boundary=frame")


@app.get("/cctv/status")
async def cctv_status():
    with _cctv_lock:
        job = _cctv_job

    if job is None:
        return {"running": False}

    return {
        "running": job.thread.is_alive() and not job.stop_event.is_set(),
        "startedAt": job.started_at.isoformat(),
        "lastCheckedAt": job.last_checked_at,
        "lastResult": job.last_result,
        "error": job.error,
        "history": list(job.history),
    }


# ── 날씨 위험도 예측 ─────────────────────────────────────────
# 모델 학습 시 사용한 특성 순서와 반드시 동일해야 함
RISK_FEATURE_ORDER = ["temperature", "min_temperature", "precipitation", "snowfall"]


class WeatherInput(BaseModel):
    temperature: float
    min_temperature: float
    precipitation: float
    snowfall: float


@app.post("/weather/predict")
async def predict_weather_risk(payload: WeatherInput):
    features = [[getattr(payload, name) for name in RISK_FEATURE_ORDER]]
    prediction = risk_model.predict(features)[0]

    return {"success": True, "riskLevel": str(prediction)}


@app.get("/health")
async def health():
    return {"status": "ok"}
