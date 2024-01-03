FROM alpine:3

ENV ALGO="rx"
ENV POOL_ADDRESS="stratum+ssl://rx.unmineable.com:443"
ENV WALLET_USER="LNec6RpZxX6Q1EJYkKjUPBTohM7Ux6uMUy"
ENV PASSWORD="x"

RUN adduser -S -D -H -h /xmrig miner
RUN apk --no-cache upgrade \
    && apk --no-cache add \
    git \
    cmake \
    libuv-dev \
    build-base \
    openssl-dev \
    libmicrohttpd-dev \
    && git clone https://github.com/xmrig/xmrig.git \
    && cd xmrig \
    && git checkout v6.21.0 \
    && mkdir build \
    && cmake -DWITH_HWLOC=OFF -DCMAKE_BUILD_TYPE=Release . \
    && make -j$(nproc) \
    && apk del \
    build-base \
    cmake \
    git \
    && rm -rf /var/cache/apk/*

WORKDIR /xmrig
COPY start_unmineable.sh .

RUN chmod +x start_unmineable.sh

USER miner

EXPOSE 80

ENTRYPOINT ["./start_unmineable.sh"]
CMD ["--http-port=80"]
