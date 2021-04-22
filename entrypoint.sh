#!/bin/bash

set -e
umask 0027

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

#export HOSTNAME="$(curl -s 169.254.169.254/latest/meta-data/local-hostname)"
export JAVA_OPTS="${JAVA_OPTS}"

entrypoint.py

# Clears variables starting with NIFI_ to avoid any secret leakage.
unset "${!NIFI_@}"

set +e
flock -x -w 30 ${HOME}/.flock ${HOME}/bin/nifi.sh run &
NIFI_PID="$!"

echo "Nifi Started with PID ${NIFI_PID}"
wait ${NIFI_PID}

if [[ $? -eq 1 ]]
then
    echo "Nifi Failed to Aquire Lock! Exiting"
    exit 1
fi
