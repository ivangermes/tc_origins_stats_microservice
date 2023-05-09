FROM python:3.11-alpine

# Force Python stdout and stderr streams to be unbuffered.
ENV PYTHONUNBUFFERED=1

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY ./source/ /app

WORKDIR /app

ENV SERVICE_HOST=localhost
ENV SERVICE_PORT=8082

ENV MONGO_URI
ENV DB_NAME
ENV COLLECTION_NAME

EXPOSE 8082

CMD set -xe; python service.py
