#!/bin/bash

set -e

USER_SPEC="${USER_SPEC:-0:0}"

if [[ ! -z ${CHOWN_DIRS+x} ]]; then
    for DIR in $CHOWN_DIRS; do
        chown -R "$USER_SPEC" $DIR
    done
fi

if [[ "$USER_SPEC" != "0:0" ]]; then
    groupadd -f -g ${USER_SPEC#*:} user
    useradd -om -g ${USER_SPEC#*:} -u ${USER_SPEC%:*} user
    export HOME=/home/user
    exec su-exec "$USER_SPEC" "$@"
fi

exec "$@"
