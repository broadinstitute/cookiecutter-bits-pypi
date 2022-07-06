FROM python:3.10-slim

{% if cookiecutter.use_pipenv == 'y' %}COPY Pipfile* /usr/src/
{% endif -%}
{% if cookiecutter.use_poetry == 'y' %}COPY poetry.lock pyproject.toml README.md /usr/src/
{% endif -%}

RUN apt-get update \
    && apt-get upgrade -yq \
    && apt-get install -yq curl g++ gcc git \
    && cd /usr/src \
    {% if cookiecutter.use_pipenv == 'y' %}&& pip install https://github.com/pypa/pipenv/archive/master.zip \
    {% endif -%}
    {% if cookiecutter.use_poetry == 'y' %}&& pip install pip poetry --upgrade \
    && if [ ! -s poetry.lock ]; then rm -f poetry.lock; fi \
    {% endif -%}
    {% if cookiecutter.use_pipenv == 'y' %}&& pipenv lock \
    && pipenv sync --dev \
    {% endif -%}
    {% if cookiecutter.use_poetry == 'y' %}&& poetry install \
    {% endif -%}
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/tmp/*

WORKDIR /usr/src

{% if cookiecutter.use_pipenv == 'y' %}ENTRYPOINT ["pipenv", "run"]
{% endif -%}
{% if cookiecutter.use_poetry == 'y' %}ENTRYPOINT ["poetry", "run"]
{% endif -%}

CMD ["bash"]
