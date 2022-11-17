FROM python:3.8-alpine
RUN apk add --no-cache --virtual build-dependencies python3-dev build-base \
 && pip install --upgrade pip \
 && pip install --no-cache-dir mkdocs \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/*
