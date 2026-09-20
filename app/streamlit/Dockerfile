# Dockerfile
FROM python:3.12-slim

# XGBoost nécessite OpenMP, absent de l'image slim
RUN apt-get update \
    && apt-get install -y --no-install-recommends libgomp1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app


COPY app/streamlit/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app/streamlit/ ./
COPY src/ ./src/
COPY . .

EXPOSE 8501
CMD ["streamlit", "run", "app.py", "--server.address=0.0.0.0", "--server.port=8501"]
