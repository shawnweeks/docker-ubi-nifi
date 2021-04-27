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

${HOME}/bin/nifi.sh run
