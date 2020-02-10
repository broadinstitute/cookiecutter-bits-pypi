FROM python:3.8-alpine

COPY Pipfile* /usr/src/

RUN apk update \
    && apk add bash curl gcc git libffi-dev libssl1.1 libxml2-dev libxslt-dev make musl-dev openssh-client openssl-dev \
    && pip install https://github.com/pypa/pipenv/archive/master.zip \
    && cd /usr/src \
    && pipenv lock \
    && pipenv sync --dev \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/tmp/*

WORKDIR /usr/src

CMD ["bash", "-l"]
