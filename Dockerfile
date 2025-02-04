# gunicorn需要先載入並更新requirements.txt

FROM python:3.12-slim

WORKDIR /app

# 安裝必要的系統依賴，包括 fontconfig
RUN apt-get update && apt-get install -y fontconfig

# 安裝 poetry
RUN pip install --no-cache-dir poetry

# 複製所有檔案
COPY . .

# 安裝 Python 依賴
RUN poetry install --no-interaction --no-ansi --no-root
RUN poetry add gunicorn==23.0.0

# 設定環境變數
ENV PYTHONUNBUFFERED=1

# 為 Cloud Run 設定動態端口
ENV PORT=8080

# 暴露端口
EXPOSE ${PORT}

# 使用 gunicorn 執行應用程式
CMD exec poetry run gunicorn --workers=2 --threads=8 --timeout=0 --bind=:${PORT} app:app