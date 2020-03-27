#!/bin/bash

DOCKER_IMAGE='{{ cookiecutter.project_slug }}:dev'
SUDO=

SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

build_image() {
    echo "Building image $DOCKER_IMAGE"
    pushd "$SCRIPT_DIR" >/dev/null || exit 1

    $SUDO docker build --pull -t "$DOCKER_IMAGE" .
    if [ $? -ne 0 ]; then
        echo 'Build failed.  Exiting!'
        exit 2
    fi

    popd >/dev/null || exit 1
}

if [ "$TERM" != 'dumb' ] ; then
    TTY='-it'
fi

if [ "$( uname -s )" != 'Darwin' ]; then
    if [ ! -w "$DOCKER_SOCKET" ]; then
        SUDO='sudo'
    fi
fi

REBUILD=
while getopts "r" OPTION; do
    case $OPTION in
        r)
            REBUILD='yes'
            shift
            ;;
        \?)
            echo 'Invalid argument.'
            exit 1
            ;;
    esac
done

if ! $SUDO docker image ls | awk '{print $1":"$2}' | grep -q "$DOCKER_IMAGE"; then
    build_image
fi

if [ -n "$REBUILD" ]; then
    build_image
fi

$SUDO docker run $TTY --rm -v "$SCRIPT_DIR":/usr/src "$DOCKER_IMAGE" "$@"
