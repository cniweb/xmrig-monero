#!/bin/bash
docker build . --tag cniweb/xmrig:6.12.1
docker tag cniweb/xmrig:6.12.1 cniweb/xmrig:latest
docker tag cniweb/xmrig:6.12.1 ghcr.io/cniweb/xmrig:6.12.1
docker tag cniweb/xmrig:6.12.1 ghcr.io/cniweb/xmrig:latest
#docker push cniweb/xmrig:6.12.1
#docker push cniweb/xmrig:latest
docker push ghcr.io/cniweb/xmrig:6.12.1
docker push ghcr.io/cniweb/xmrig:latest