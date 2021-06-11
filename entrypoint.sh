#!/bin/bash

set -e
umask 0027

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

#export HOSTNAME="$(curl -s 169.254.169.254/latest/meta-data/local-hostname)"
export JAVA_OPTS="${JAVA_OPTS}"

if [ -n "$NIFI_SSL_KEY" ]; then
    if [ -z "$NIFI_SSL_CERT" ]; then
        echo "Missing NIFI_SSL_CERT" >&2
        exit 1
    fi
    if [ -z "$NIFI_SSL_KEY_PASS" ]; then
        echo "Missing NIFI_SSL_KEY_PASS" >&2
        exit 1
    fi
    echo "$NIFI_SSL_KEY" > ${HOME}/nifi_ssl_key.key
    echo "$NIFI_SSL_CERT" > ${HOME}/nifi_ssl_cert.pem
    
    openssl pkcs12 -export -name nifi-key -in ${HOME}/nifi_ssl_cert.pem -inkey ${HOME}/nifi_ssl_key.key -out ${HOME}/nifi_ssl.p12 -passin env:NIFI_SSL_KEY_PASS -passout env:NIFI_SSL_KEY_PASS
    
    keytool -importkeystore -srckeystore ${HOME}/nifi_ssl.p12 -srcstoretype PKCS12 -srcstorepass $NIFI_SSL_KEY_PASS -deststorepass changeit -destkeystore ${HOME}/keystore.jks -deststoretype JKS
    
    rm ${HOME}/nifi_ssl_key.key
    rm ${HOME}/nifi_ssl_cert.pem
    rm ${HOME}/nifi_ssl.p12
    
    export NIFI_SECURITY_KEYSTORE="${HOME}/keystore.jks"
    export NIFI_SECURITY_KEYSTORE_TYPE="JKS"
    export NIFI_SECURITY_KEYSTORE_PASSWD="changeit"
    export NIFI_SECURITY_KEY_PASSWD="$NIFI_SSL_KEY_PASS"

fi

entrypoint.py

# Clears variables starting with NIFI_ to avoid any secret leakage.
unset "${!NIFI_@}"

${HOME}/bin/nifi.sh run
