#!/usr/bin/env bash

declare -g CHKSUM_APP
declare -g CONTAINER_APP
declare -g CONTAINER_IMAGE
declare -g DOCKER_SOCKET
declare -g LABEL_PREFIX
declare -g SCRIPT_DIR
declare -g stored
declare -g SUDO
declare -ga TRACK_FILES
declare -ga TTY

CONTAINER_IMAGE='{{ cookiecutter.project_slug }}:dev'
DOCKER_SOCKET='/var/run/docker.sock'
LABEL_PREFIX='org.broadinstitute.{{ cookiecutter.project_slug }}'
{% if cookiecutter.use_pipenv == 'y' %}TRACK_FILES=( Dockerfile Pipfile )
{% endif -%}
{% if cookiecutter.use_poetry == 'y' %}TRACK_FILES=( Dockerfile poetry.lock pyproject.toml )
{% endif -%}

SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if which sha256sum >/dev/null; then
    CHKSUM_APP='sha256sum'
elif which shasum >/dev/null; then
    CHKSUM_APP='shasum -a 256'
elif which md5sum >/dev/null; then
    CHKSUM_APP='md5sum'
else
    echo 'Could not find a checksumming program. Exiting!'
    exit 1
fi

if which docker >/dev/null; then
    CONTAINER_APP='docker'
elif which podman >/dev/null; then
    CONTAINER_APP='podman'
else
    echo 'Container environment cannot be found. Exiting!'
    exit 2
fi

function build_check() {
    local rebuild
    local tfile
    local stored

    if ! $SUDO $CONTAINER_APP image ls | awk '{print $1":"$2}' | grep --quiet -E "^(localhost\/)*${CONTAINER_IMAGE}"; then
        rebuild='1'
    else
        rebuild='0'
        for tfile in "${TRACK_FILES[@]}"; do
            current="$( $CHKSUM_APP "$tfile" | cut -d' ' -f1 )"
            stored="$( $CONTAINER_APP image inspect --format="{% raw %}{{index .Config.Labels \"${LABEL_PREFIX}.${tfile}\"}}{% endraw %}" "$CONTAINER_IMAGE" )"

            if [ "$current" != "$stored" ]; then
                echo "$tfile changed.  Rebuilding."
                rebuild='1'
            fi
        done
    fi

    if [ "$rebuild" == '1' ]; then
        build "$CONTAINER_IMAGE"
    fi
}

function build() {
    local label
    local tfile

    if [ -z "$1" ]; then
        echo 'Image name not provided to build. Exiting!'
        exit 1
    fi
    CONTAINER_IMAGE=$1

    if [[ $(git diff --stat) != '' ]]; then
        echo 'Branch is dirty.  The build can only happen on an unmodified branch.'
        exit 2
    fi

    LABELS=
    for tfile in "${TRACK_FILES[@]}"; do
        label="$( $CHKSUM_APP "$tfile" | awk -v PREFIX="$LABEL_PREFIX" '{print PREFIX"."$2"="$1}' )"
        LABELS+="--label ${label} "
    done

    $SUDO $CONTAINER_APP build --pull -t "$CONTAINER_IMAGE" $LABELS .
}

if [ "$TERM" != 'dumb' ] ; then
    TTY=( -it )
fi

if [ "$( uname -s )" != 'Darwin' ]; then
    if [ ! -w "$DOCKER_SOCKET" ]; then
        SUDO='sudo'
    fi
fi

pushd "$SCRIPT_DIR" >/dev/null || exit 1

# Test if a build is needed and, if so, kick one off
build_check

$SUDO $CONTAINER_APP run "${TTY[@]}" --rm \
    -v "${SCRIPT_DIR}:/working" \
    "$CONTAINER_IMAGE" "$@"

popd >/dev/null || exit 1
