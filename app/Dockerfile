FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip3 install --no-cache-dir flask==3.0.0 gunicorn==21.2.0

COPY app.py .

ENV APP_VERSION=1.0.0
ENV PYTHONUNBUFFERED=1

EXPOSE 8080

CMD ["python3", "-m", "gunicorn", "-w", "2", "-b", "0.0.0.0:8080", "app:app"]

