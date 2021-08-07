FROM  alpine:3
RUN   adduser -S -D -H -h /xmrig miner
RUN   apk --no-cache upgrade && \
      apk --no-cache add \
        git \
        cmake \
        libuv-dev \
        build-base \
        openssl-dev \
        libmicrohttpd-dev && \
      git clone https://github.com/xmrig/xmrig && \
      cd xmrig && \
      git checkout v6.12.2 && \
      mkdir build && \
      cmake -DWITH_HWLOC=OFF -DCMAKE_BUILD_TYPE=Release . && \
      make && \
      apk del \
        build-base \
        cmake \
        git
USER miner
WORKDIR    /xmrig
COPY config.json /xmrig
EXPOSE 80
ENTRYPOINT  ["./xmrig"]