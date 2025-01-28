# 使用 Python 3.12 版本的基本映像
FROM python:3.12.8-slim-bookworm

# 設置工作目錄
WORKDIR /app

# 複製依賴檔案
COPY requirements.txt ./

# 設置環境變數
ENV TZ=Asia/Taipei \
    LANG=C.UTF-8 \
    PYTHONUNBUFFERED=1

# 安裝所有依賴項、gunicorn
RUN apt update && \
    pip3 install -r requirements.txt gunicorn

# ----------------------------------------------------------------

# 複製應用程式源代碼
COPY . ./

# 設置容器的啟動命令，使用 gunicorn WSGI HTTP 服務器部署應用並設置端口為 5000 (--workers1 --threads 1 讓 GCP 自行擴展即可)
CMD ["bash", "-c", "gunicorn app:app -b :${PORT:-5000} --workers ${WORKERS:-1} --threads ${THREADS:-1}"]
