FROM python:3.10-slim

WORKDIR /mlflow/

ARG MLFLOW_VERSION
RUN pip install --no-cache-dir mlflow==${MLFLOW_VERSION}

EXPOSE 2002

CMD mlflow server \ 
    --backend-store-uri ${BACKEND_STORE_URI} \
    --serve-artifacts \
    --host 0.0.0.0 \
    --port 2002