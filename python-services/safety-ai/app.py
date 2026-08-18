import io

import joblib
from fastapi import FastAPI, File, UploadFile
from PIL import Image
from pydantic import BaseModel
from ultralytics import YOLO

app = FastAPI()

helmet_model = YOLO("best.pt")

# risk_model.pkl은 {"model": ..., "features": [...], "labels": [...]} 형태의 딕셔너리로 저장되어 있음
_risk_bundle = joblib.load("risk_model.pkl")
risk_model = _risk_bundle["model"]

# ── 안전모 탐지 ──────────────────────────────────────────────
# 로보플로우 클래스 체계: helmet(착용) / head(미착용) / person(참고용, 판정에 미사용)
HELMET_LABEL = "helmet"
NO_HELMET_LABEL = "head"
CONFIDENCE_THRESHOLD = 0.5


@app.post("/helmet/predict")
async def predict_helmet(file: UploadFile = File(...)):
    image_bytes = await file.read()
    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")

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
