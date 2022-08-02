FROM python:3.6.8-slim as builder

COPY requirements.txt .

RUN pip wheel --no-cache-dir --no-deps --wheel-dir wheels -r requirements.txt

FROM python:3.6.8-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY --from=builder wheels wheels
COPY --from=builder requirements.txt .
COPY ./app /app

RUN pip install --no-cache /wheels/* && useradd --create-home appuser
USER appuser
RUN python /app/ntlk_extras.py


CMD ["python", "/app/main.py"]
