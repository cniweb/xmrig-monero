#!/bin/bash

docker build . --tag cniweb/xmrig:6.6.2
docker tag cniweb/xmrig:6.6.2 cniweb/xmrig:latest
docker push cniweb/xmrig:6.6.2
docker push cniweb/xmrig:latest