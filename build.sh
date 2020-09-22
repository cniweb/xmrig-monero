#!/bin/bash

docker build . --tag cniweb/xmrig:latest
docker push cniweb/xmrig:latest