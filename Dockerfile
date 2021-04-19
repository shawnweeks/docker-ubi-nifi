ARG BASE_REGISTRY
ARG BASE_IMAGE=redhat/ubi/ubi8
ARG BASE_TAG=8.3

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as build

ARG NIFI_VERSION
ARG NIFI_PACKAGE=nifi-${NIFI_VERSION}-bin.tar.gz

COPY [ "${NIFI_PACKAGE}", "/tmp/" ]

RUN mkdir -p /tmp/nifi_package && \
    tar -xf /tmp/${NIFI_PACKAGE} -C "/tmp/nifi_package" --strip-components=1 && \
    mkdir -p /tmp/nifi_package/conf && \
    mkdir -p /tmp/nifi_package/content_repository && \
    mkdir -p /tmp/nifi_package/database_repository && \
    mkdir -p /tmp/nifi_package/flowfile_repository && \
    mkdir -p /tmp/nifi_package/provenance_repository && \
    mkdir -p /tmp/nifi_package/state && \
    mkdir -p /tmp/nifi_package/work && \
    mkdir -p /tmp/nifi_package/logs && \
    mkdir -p /tmp/nifi_package/run

###############################################################################
# ARG BASE_REGISTRY
# ARG BASE_IMAGE=redhat/ubi/ubi8
# ARG BASE_TAG=8.3

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

ENV NIFI_USER nifi
ENV NIFI_GROUP nifi
ENV NIFI_UID 2001
ENV NIFI_GID 2001

ENV NIFI_HOME /opt/nifi

RUN yum install -y java-11-openjdk-devel && \
    yum clean all && \
    mkdir -p ${NIFI_HOME} && \
    groupadd -r -g ${NIFI_GID} ${NIFI_GROUP} && \
    useradd -r -u ${NIFI_UID} -g ${NIFI_GROUP} -M -d ${NIFI_HOME} ${NIFI_USER} && \
    chown ${NIFI_USER}:${NIFI_GROUP} ${NIFI_HOME} -R

COPY [ "templates/*.j2", "/opt/jinja-templates/" ]
COPY --from=build --chown=${NIFI_USER}:${NIFI_GROUP} [ "/tmp/nifi_package", "${NIFI_HOME}/" ]
COPY --chown=${NIFI_USER}:${NIFI_GROUP} [ "entrypoint.sh", "entrypoint.py", "entrypoint_helpers.py", "${NIFI_HOME}/" ]

RUN chmod 755 ${NIFI_HOME}/entrypoint.*

EXPOSE 8080 9443 10443 11443 6342

VOLUME ${NIFI_HOME}/content_repository
VOLUME ${NIFI_HOME}/database_repository
VOLUME ${NIFI_HOME}/flowfile_repository
VOLUME ${NIFI_HOME}/provenance_repository
VOLUME ${NIFI_HOME}/state
VOLUME ${NIFI_HOME}/work
VOLUME ${NIFI_HOME}/logs
VOLUME ${NIFI_HOME}/conf

USER ${NIFI_USER}
ENV JAVA_HOME=/usr/lib/jvm/java-11
ENV PATH=${PATH}:${NIFI_HOME}
WORKDIR ${NIFI_HOME}
ENTRYPOINT [ "entrypoint.sh" ]