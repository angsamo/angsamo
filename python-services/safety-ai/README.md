# 안전관리 AI 추론 서버 (팀 서버 배포용)

안전모 탐지(YOLO)와 날씨 위험도 예측(scikit-learn) 두 모델을 하나의 서버에서 서빙합니다.
스프링부트가 경로별로 각각 호출합니다.

| 엔드포인트 | 용도 | 모델 |
|---|---|---|
| `POST /helmet/predict` | 사진 속 안전모 착용 여부 판정 | `best.pt` (로보플로우 YOLO11, 직접 준비) |
| `POST /weather/predict` | 오늘 날씨 값으로 위험도 판정 | `risk_model.pkl` (전달받음, 폴더에 포함됨) |
| `GET /health` | 서버 상태 확인 | - |

## 1. 준비물

- **`best.pt`**: 이 폴더(`python-services/safety-ai/`)에 로보플로우에서 받은 YOLO11 가중치 파일을 복사해 넣어야 합니다 (아직 미포함 — 팀원에게 데이터셋 export 받아서 Colab 재학습 후 추가 예정).
- **`risk_model.pkl`**: 이미 포함되어 있음 (팀원이 전달한 학습 결과물).
- 안전모 클래스는 `helmet`(착용) / `head`(미착용) / `person`(참고용) 3종으로 고정. 실제 클래스명이 다르면 `app.py`의 `HELMET_LABEL` / `NO_HELMET_LABEL` 수정.
- 날씨 위험도 모델 입력 순서(`temperature, min_temperature, precipitation, snowfall`)는 학습 때와 반드시 동일해야 함 — `app.py`의 `RISK_FEATURE_ORDER` 임의 변경 금지.
- `requirements.txt`의 `scikit-learn==1.6.1`은 날씨 모델 학습 버전과 맞춘 것 — 버전 다르면 예측이 어긋날 수 있음.

## 2. 팀 서버(mbc-sw.iptime.org)에 배포

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# 5001 포트로 외부에서도 접근 가능하게 실행 (0.0.0.0 필수)
uvicorn app:app --host 0.0.0.0 --port 5001
```

계속 켜두려면 `nohup uvicorn app:app --host 0.0.0.0 --port 5001 &` 로 백그라운드 실행하거나,
서버 관리자가 systemd 서비스로 등록하는 걸 추천합니다.

## 3. 동작 확인

```bash
curl http://mbc-sw.iptime.org:5001/health
# {"status":"ok"}

curl -X POST -F "file=@test.jpg" http://mbc-sw.iptime.org:5001/helmet/predict
# {"success":true,"status":"pass","helmetWorn":true,"helmetCount":4,"noHelmetCount":0,...}

curl -X POST http://mbc-sw.iptime.org:5001/weather/predict \
  -H "Content-Type: application/json" \
  -d '{"temperature": 34, "min_temperature": 26, "precipitation": 0, "snowfall": 0}'
# {"success":true,"riskLevel":"DANGER"}
```

## 4. 스프링부트 연동

- `application.properties`
  - `helmet.detection-api-url=http://mbc-sw.iptime.org:5001/helmet/predict`
  - `weather.risk-api-url=http://mbc-sw.iptime.org:5001/weather/predict` (아직 Java 연동 코드는 없음, 남은 작업)
- 안전모는 이미 연동 완료 (`HelmetDetectionService` → `SafetyChecklistService.addItem()`에서 사진 첨부 시 자동 호출).
- 날씨는 `WeatherService.calculateRiskLevel()`(규칙 기반)을 이 서버 호출로 교체하는 작업이 남아있음. 서버가 꺼져있거나 응답 실패 시엔 기존 방식(안전모는 수동 입력값, 날씨는 규칙 기반)으로 자동 대체(fallback)하도록 만들 것.
