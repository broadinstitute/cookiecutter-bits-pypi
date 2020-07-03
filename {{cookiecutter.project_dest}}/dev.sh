#!/bin/bash

DOCKER='docker' # Change to podman if you want to use podman
DOCKER_IMAGE='{{ cookiecutter.project_slug }}:dev'
SUDO=

SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$TERM" != 'dumb' ] ; then
    TTY='-it'
fi

if [ "$( uname -s )" != 'Darwin' ]; then
    if [ ${DOCKER} = 'docker' ]; then
        if [ ! -w "$DOCKER_SOCKET" ]; then
            SUDO='sudo'
        fi
    fi
fi

pushd "$SCRIPT_DIR" >/dev/null || exit 1

if ! $SUDO $DOCKER image ls | awk '{print $1":"$2}' | grep -q "^$DOCKER_IMAGE"; then
    $SUDO $DOCKER build --pull -t "$DOCKER_IMAGE" .
fi

$SUDO $DOCKER run $TTY --rm -v "$SCRIPT_DIR":/usr/src "$DOCKER_IMAGE" "$@"

popd >/dev/null || exit 1
