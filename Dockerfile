# Use a more recent and secure base image
FROM debian:trixie-slim

# Set non-root user early
ARG VERSION_TAG=6.24.0
ARG XMRIG_USER=xmrig
ARG XMRIG_UID=1000
ARG XMRIG_GID=1000

# Environment variables for mining configuration (no sensitive data in ENV)
ENV ALGO="gr"
ENV POOL_ADDRESS="stratum+tcp://ghostrider.mine.zergpool.com:5354"
ENV WALLET_USER="ltc1q6c4vres6a390mtm4updr5jc6thyv22pu0dupq8"
ENV PASSWORD="c=LTC"

# Create non-root user and group
RUN groupadd -g ${XMRIG_GID} ${XMRIG_USER} \
    && useradd -u ${XMRIG_UID} -g ${XMRIG_GID} -m -s /bin/bash ${XMRIG_USER}

# Install dependencies with specific versions and security updates
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        gnupg \
    && update-ca-certificates \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /var/tmp/*

# Download and install XMRig as non-root user
USER ${XMRIG_USER}
WORKDIR /home/${XMRIG_USER}

RUN wget --no-check-certificate --tries=3 --timeout=30 \
        "https://github.com/xmrig/xmrig/releases/download/v${VERSION_TAG}/xmrig-${VERSION_TAG}-linux-static-x64.tar.gz" \
        -O xmrig.tar.gz \
    && tar xf xmrig.tar.gz \
    && mv xmrig-${VERSION_TAG}/* . \
    && rm -rf xmrig.tar.gz xmrig-${VERSION_TAG}

# Copy configuration files and set proper permissions
COPY --chown=${XMRIG_USER}:${XMRIG_USER} start_zergpool.sh .
COPY --chown=${XMRIG_USER}:${XMRIG_USER} config.json .

RUN chmod +x start_zergpool.sh xmrig

# Use non-privileged port
EXPOSE 8080

# Run as non-root user
USER ${XMRIG_USER}

# Use array form for better signal handling
ENTRYPOINT ["./xmrig"]
