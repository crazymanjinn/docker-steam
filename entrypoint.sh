#!/bin/bash

USER_SPEC="${USER_SPEC:-0:0}"

if [[ ! -z ${CHOWN_DIRS+x} ]]; then
    for DIR in $CHOWN_DIRS; do
        printf "chown -R %s %s\n" "$USER_SPEC" $DIR
        chown -R "$USER_SPEC" $DIR
    done
fi

if [[ "$USER_SPEC" != "0:0" ]]; then
    gid=${USER_SPEC#*:}
    groupadd -f -g $gid user
    useradd -om -g $gid -u ${USER_SPEC%:*} user
    export HOME=/home/user
    chown -R "$USER_SPEC" $HOME
    printf "su-exec %s %s\n" "$USER_SPEC" "$@"
    exec su-exec "$USER_SPEC" "$@"
fi

exec "$@"
