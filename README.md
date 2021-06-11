### Download Packages
```shell
export NIFI_VERSION=1.13.2
wget https://archive.apache.org/dist/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.tar.gz
```

### Build Command
```shell
export NIFI_VERSION=1.13.2
docker build \
    -t ${REGISTRY}/apache/nifi:${NIFI_VERSION} \
    --build-arg BASE_REGISTRY=$REGISTRY \
    --build-arg NIFI_VERSION=${NIFI_VERSION} \
    .
```

### Push to Registry
```shell
export NIFI_VERSION=1.13.2
docker push ${REGISTRY}/apache/nifi:${NIFI_VERSION}
```

### Simple Run Command
```shell
docker run --init -it --rm \
    --name nifi  \
    -p 8080:8080 \
    -e NIFI_NODES=server1,server2,server3 \
    --entrypoint bash \
    $REGISTRY/apache/nifi:1.13.2
```

### Compose Run
```shell
export NIFI_VERSION=1.13.2
export ZOOKEEPER_VERSION=3.6.2
docker-compose up
```
### Deploy to ECS
```shell
aws ecs register-task-definition --cli-input-json file://dev_task_def.json
aws ecs create-service --cli-input-json file://dev_service_def.json
aws ecs update-service --cli-input-json file://dev_service_upd.json
```

### Environment Variables
| Variable Name | Description | Default Value |
| --- | --- | --- |
| NIFI_SSL_KEY | Key string to import into keystore.jks. | |
| NIFI_SSL_KEY_PASS | Key passphrase. | |
| NIFI_SSL_CERT | Certificate string to import into keystore.jks. | |