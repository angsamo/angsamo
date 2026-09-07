# 안전관리 AI 추론 서버 (로컬 실행용)

안전모 탐지(YOLO)와 날씨 위험도 예측(scikit-learn), CCTV 실시간 탐지 세 기능을
하나의 서버에서 서빙합니다. 스프링부트가 경로별로 각각 호출합니다.

현재는 팀 공용 서버가 아니라 **로컬(localhost:5001)에서만 실행**하는 것으로 운영합니다.
(CCTV는 카메라가 로컬 네트워크에 있어야 접근 가능해서 팀 서버 상시 배포는 하지 않음.)

| 엔드포인트 | 용도 | 모델 |
|---|---|---|
| `POST /helmet/predict` | 사진 속 안전모 착용 여부 판정 | `best.pt` |
| `POST /cctv/start`, `/cctv/stop`, `GET /cctv/status`, `/cctv/stream` | CCTV 실시간 탐지 시작/종료/상태/영상 스트림 | `best.pt` |
| `POST /weather/predict` | 오늘 날씨 값으로 위험도 판정 | `risk_model.pkl` |
| `GET /health` | 서버 상태 확인 | - |

## 1. 준비물

- **`best.pt`**: 로보플로우에서 재학습한 YOLO11 가중치 (이미 포함되어 있음).
  안전모 클래스는 `helmet`(착용) / `head`(미착용) **2종**으로 고정.
  (초기 3-class 모델은 `person` 클래스 정확도가 너무 낮아 재학습하며 제외했습니다.)
- **`risk_model.pkl`**: 날씨 위험도 판정 모델. 입력 순서(`temperature, min_temperature,
  precipitation, snowfall`)는 학습 때와 반드시 동일해야 함 — `app.py`의
  `RISK_FEATURE_ORDER` 임의 변경 금지.
- `requirements.txt`의 `scikit-learn==1.6.1`은 날씨 모델 학습 버전과 맞춘 것.

## 2. 로컬 실행

```bash
python -m venv venv
venv\Scripts\activate.bat   # Windows
pip install -r requirements.txt
uvicorn app:app --host 0.0.0.0 --port 5001
```

Windows에서는 `start-server.bat`을 더블클릭하면 venv 생성부터 서버 실행까지 자동으로 됩니다.

## 3. 동작 확인

```bash
curl http://localhost:5001/health
# {"status":"ok"}

curl -X POST -F "file=@test.jpg" http://localhost:5001/helmet/predict
# {"success":true,"status":"pass","helmetWorn":true,"helmetCount":1,"noHelmetCount":0,...}

curl -X POST http://localhost:5001/weather/predict \
  -H "Content-Type: application/json" \
  -d '{"temperature": 34, "min_temperature": 26, "precipitation": 0, "snowfall": 0}'
# {"success":true,"riskLevel":"DANGER"}
```

## 4. 스프링부트 연동

`application.properties` (기본값 그대로 localhost:5001을 가리킴):
- `helmet.detection-api-url=http://localhost:5001/helmet/predict`
- `weather.risk-api-url=http://localhost:5001/weather/predict`
- `cctv.api-base-url=http://localhost:5001`
- `cctv.rtsp-url` — 카메라 RTSP 주소 (환경변수 `CCTV_RTSP_URL`로 로컬에만 설정, 커밋 금지)

날씨/안전모 호출은 모두 자바 표준 `HttpClient`를 HTTP/1.1로 고정해서 사용합니다.
(`RestClient`의 h2c 업그레이드 시도를 uvicorn이 처리하지 못해 요청 본문이 유실되는
문제가 있었음 — `HelmetDetectionService`, `WeatherService` 참고.)

서버가 꺼져 있거나 응답 실패 시 자동 대체(fallback)됩니다:
- 안전모: AI 판정 실패 시 체크리스트 화면의 수동 입력값 사용
- 날씨: AI 판정 실패 시 규칙 기반 위험도 계산으로 대체

## 5. CCTV 실시간 탐지

- `/safety/cctv` 화면에서 시작하면 15초 간격으로 프레임을 캡처해 판정합니다.
- 실시간 영상 자체에는 탐지 박스를 그리지 않습니다 (박스 갱신 주기와 영상 프레임 주기가
  달라 움직이는 사람을 못 따라가서 어긋나 보이는 문제 때문).
- 탐지할 때마다 박스가 그려진 스냅샷을 `cctv_logs/` 폴더에 저장하고, 탐지 이력 목록에서
  확인할 수 있습니다. 로그는 최근 100개까지만 유지되고 오래된 이미지는 자동 삭제됩니다.

## 6. 알려진 한계

- 학습 데이터가 전부 **실외 건설현장(안전조끼 착용) 사진**이라, 실내/웹캠처럼 학습
  분포와 다른 환경에서는 정확도가 떨어집니다 (특히 `head`(미착용) 판정이 잘 안 나옴).
  실제 현장 사진 기준으로는 Precision 92%, Recall 87% 수준입니다.
