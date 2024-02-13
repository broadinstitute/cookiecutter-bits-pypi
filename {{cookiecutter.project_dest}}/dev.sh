#!/bin/bash

DOCKER_IMAGE='{{ cookiecutter.project_slug }}:dev'
LABEL_PREFIX='org.broadinstitute.{{ cookiecutter.project_slug }}'
{% if cookiecutter.use_pipenv == 'y' %}TRACK_FILES=( Dockerfile Pipfile )
{% endif -%}
{% if cookiecutter.use_poetry == 'y' %}TRACK_FILES=( Dockerfile poetry.lock pyproject.toml )
{% endif -%}
SUDO=

SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if which sha256sum >/dev/null; then
    CHKSUM='sha256sum'
elif which shasum >/dev/null; then
    CHKSUM='shasum -a 256'
elif which md5sum >/dev/null; then
    CHKSUM='md5sum'
else
    echo 'Could not find a checksumming program. Exiting!'
    exit 1
fi

if which docker >/dev/null; then
    DOCKER='docker'
elif which podman >/dev/null; then
    DOCKER='podman'
else
    echo 'Container environment cannot be found. Exiting!'
    exit 2
fi

function build() {
    if [ -z "$1" ]; then
        echo 'Image name not provided to build. Exiting!'
        exit 1
    fi
    DOCKER_IMAGE=$1

    if [[ $(git diff --stat) != '' ]]; then
        echo 'Branch is dirty.  The build can only happen on an unmodified branch.'
        exit 2
    fi

    LABELS=
    for tfile in "${TRACK_FILES[@]}"; do
        label="$( $CHKSUM "$tfile" | awk -v PREFIX="$LABEL_PREFIX" '{print PREFIX"."$2"="$1}' )"
        LABELS+="--label ${label} "
    done

    $SUDO $DOCKER build --pull -t "$DOCKER_IMAGE" $LABELS .
}


if [ "$TERM" != 'dumb' ] ; then
    TTY='-it'
fi

if [ "$( uname -s )" != 'Darwin' ]; then
    if [ ! -w "$DOCKER_SOCKET" ]; then
        SUDO='sudo'
    fi
fi

pushd "$SCRIPT_DIR" >/dev/null || exit 1
IMG_TEST="$( $SUDO $DOCKER image ls | awk '{print $1":"$2}' | grep "^${DOCKER_IMAGE}" )"
if [ -z "$IMG_TEST" ]; then
    build "$DOCKER_IMAGE"
fi

rebuild='0'
for tfile in "${TRACK_FILES[@]}"; do
    current="$( $CHKSUM "$tfile" | cut -d' ' -f1 )"
    stored="$( $DOCKER image inspect --format="{% raw %}{{index .Config.Labels \"${LABEL_PREFIX}.${tfile}\"}}{% endraw %}" "$DOCKER_IMAGE" )"

    if [ "$current" != "$stored" ]; then
        echo "$tfile changed.  Rebuilding."
        rebuild='1'
    fi
done

if [ "$rebuild" == "1" ]; then
    build "$DOCKER_IMAGE"
fi

$SUDO $DOCKER run $TTY --rm -v "$SCRIPT_DIR":/working "$DOCKER_IMAGE" "$@"

popd >/dev/null || exit 1
