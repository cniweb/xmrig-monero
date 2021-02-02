#!/bin/bash
docker build . --tag cniweb/xmrig:6.8.0
docker tag cniweb/xmrig:6.8.0 cniweb/xmrig:latest
docker push cniweb/xmrig:6.8.0
docker push cniweb/xmrig:latest