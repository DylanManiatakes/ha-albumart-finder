# ./Dockerfile
FROM python:3.12-alpine

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app
COPY run.py /app/run.py

# deps
RUN apk add --no-cache curl && \
    pip install flask paho-mqtt requests

# data dir for the served jpg (bind/mount this if you want persistence)
ENV STATIC_DIR=/data/albumart
RUN mkdir -p ${STATIC_DIR}

EXPOSE 8099

# basic healthcheck: /status should return JSON
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s CMD curl -fsS http://127.0.0.1:8099/status || exit 1

CMD ["python", "/app/run.py"]