### Build Command
```shell
docker build \
    -t $REGISTRY/apache/nifi:1.12.1 \
    --build-arg BASE_REGISTRY=$REGISTRY \
    --build-arg NIFI_VERSION=1.12.1 \
    .
```

### Push to Registry
```shell
docker tag $REGISTRY/atlassian-suite/docker-crowd-server-sso:4.1.1 $REGISTRY/atlassian-suite/docker-crowd-server-sso:4.1.1.$(date +"%Y%m%d%H%M%S")
docker push $REGISTRY/atlassian-suite/docker-crowd-server-sso
```

### Simple Run Command
```shell
docker run --init -it --rm \
    --name nifi  \
    -p 8080:8080 \
    $REGISTRY/apache/nifi:1.12.1
```