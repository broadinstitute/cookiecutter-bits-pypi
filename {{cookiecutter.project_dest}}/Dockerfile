FROM python:3.8-alpine

{% if cookiecutter.use_pipenv == 'y' %}COPY Pipfile* /usr/src/
{% endif -%}
{% if cookiecutter.use_poetry == 'y' %}COPY pyproject.toml README.md /usr/src/
{% endif -%}

RUN apk update \
    && apk add bash curl gcc git libffi-dev libssl1.1 libxml2-dev libxslt-dev make musl-dev openssh-client openssl-dev \
    {% if cookiecutter.use_pipenv == 'y' %}&& pip install https://github.com/pypa/pipenv/archive/master.zip \
    {% endif -%}
    {% if cookiecutter.use_poetry == 'y' %}&& pip install poetry \
    {% endif -%}
    && cd /usr/src \
    {% if cookiecutter.use_pipenv == 'y' %}&& pipenv lock \
    && pipenv sync --dev \
    {% endif -%}
    {% if cookiecutter.use_poetry == 'y' %}&& poetry install \
    {% endif -%}
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/tmp/*

WORKDIR /usr/src

CMD ["bash", "-l"]
