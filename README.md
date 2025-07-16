# XMRig

![XMRig](https://avatars0.githubusercontent.com/u/27528955?s=460&u=555699fb82e7598ed7dd1f6e47302042b48a10c3&v=4)

High performance, open source RandomX, CryptoNight, AstroBWT and Argon2 CPU/GPU Miner Docker Image.

[![Build & Push Docker Image](https://github.com/cniweb/xmrig-monero/actions/workflows/docker-build.yml/badge.svg)](https://github.com/cniweb/xmrig-monero/actions/workflows/docker-build.yml) [![Snyk Container](https://github.com/cniweb/xmrig-monero/actions/workflows/snyk-container-analysis.yml/badge.svg)](https://github.com/cniweb/xmrig-monero/actions/workflows/snyk-container-analysis.yml) ![Docker Pulls](https://img.shields.io/docker/pulls/cniweb/xmrig)

## Available Container Registries

This Docker image is automatically built and pushed to multiple container registries on every commit to the main branch:

### Docker Hub (docker.io)
```bash
# Pull and run latest version
docker run docker.io/cniweb/xmrig:latest

# Pull specific commit
docker run docker.io/cniweb/xmrig:<commit-sha>
```

### GitHub Container Registry (ghcr.io)
```bash
# Pull and run latest version
docker run ghcr.io/cniweb/xmrig:latest

# Pull specific commit
docker run ghcr.io/cniweb/xmrig:<commit-sha>
```

Link: <https://github.com/cniweb/xmrig-monero/pkgs/container/xmrig>

### Quay.io
```bash
# Pull and run latest version
docker run quay.io/cniweb/xmrig:latest

# Pull specific commit
docker run quay.io/cniweb/xmrig:<commit-sha>
```

## Available Tags

- `latest` - Latest stable build from the main branch
- `<commit-sha>` - Specific commit version (e.g., `a1b2c3d4...`)
- `6.22.2` - Version-specific tags (legacy)
