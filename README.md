### Download Packages
```shell
export NIFI_VERSION=1.12.1
wget https://archive.apache.org/dist/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.tar.gz
```

### Build Command
```shell
export NIFI_VERSION=1.12.1
docker build \
    -t ${REGISTRY}/apache/nifi:${NIFI_VERSION} \
    --build-arg BASE_REGISTRY=$REGISTRY \
    --build-arg NIFI_VERSION=${NIFI_VERSION} \
    .
```

### Push to Registry
```shell
export NIFI_VERSION=1.12.1
docker push ${REGISTRY}/apache/nifi:${NIFI_VERSION}
```

### Simple Run Command
```shell
docker run --init -it --rm \
    --name nifi  \
    -p 8080:8080 \
    -e NIFI_NODES=server1,server2,server3 \
    --entrypoint bash \
    $REGISTRY/apache/nifi:1.12.1
```