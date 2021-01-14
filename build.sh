#!/bin/bash
docker build . --tag cniweb/xmrig:6.7.1
docker tag cniweb/xmrig:6.7.1 cniweb/xmrig:latest
docker push cniweb/xmrig:6.7.1
docker push cniweb/xmrig:latest