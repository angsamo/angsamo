@echo off
cd /d %~dp0
if not exist venv (
    echo [INFO] creating venv...
    python -m venv venv
    call venv\Scripts\activate.bat
    pip install -r requirements.txt
) else (
    call venv\Scripts\activate.bat
)
echo [INFO] starting server on port 5001. closing this window stops the server.
uvicorn app:app --host 0.0.0.0 --port 5001
pause
													