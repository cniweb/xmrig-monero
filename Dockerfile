FROM debian:stable-slim

ARG VERSION_TAG=6.24.0
ENV ALGO="gr"
ENV POOL_ADDRESS="stratum+tcp://ghostrider.mine.zergpool.com:5354"
ENV WALLET_USER="ltc1q6c4vres6a390mtm4updr5jc6thyv22pu0dupq8"
ENV PASSWORD="c=LTC"

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install curl wget \
    && cd /opt \
    && curl -L https://github.com/xmrig/xmrig/releases/download/v${VERSION_TAG}/xmrig-${VERSION_TAG}-linux-static-x64.tar.gz -o xmrig.tar.gz \
    && tar xf xmrig.tar.gz \
    && ls -lisah \
    && rm -rf xmrig.tar.gz \
    && mv /opt/xmrig-${VERSION_TAG}/ /opt/xmrig/ \
    && apt-get -y autoremove --purge \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

WORKDIR /opt/xmrig/
COPY start_zergpool.sh .
COPY config.json .

RUN chmod +x start_zergpool.sh

EXPOSE 80

ENTRYPOINT ["./xmrig"]
