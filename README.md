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

## Runtime Profiles

### Default Linux RandomX Profile

The default [xmrig-monero/compose.yaml](xmrig-monero/compose.yaml) now targets native Linux RandomX mining directly from the published registry image. No local Docker build is required.

It does the following by default when you run it on Linux:

- starts the container as `root`
- runs the published image from `ghcr.io/cniweb/xmrig:latest`
- requests MSR access
- requests Huge Pages JIT
- requests RandomX 1GB Huge Pages
- tries to reserve Huge Pages from inside the privileged container before starting XMRig

Usage:

```bash
cp .env.randomx.example .env
docker compose up -d xmrig
```

Adjust at least `POOL_ADDRESS`, `WALLET_USER`, and `PASSWORD` in `.env` before you start it.

### RandomX Example Files

The repository now includes two RandomX-oriented examples:

- [xmrig-monero/.env.randomx.example](xmrig-monero/.env.randomx.example) for runtime values used by Compose
- [xmrig-monero/config.randomx.json](xmrig-monero/config.randomx.json) as a Monero/RandomX-oriented standalone XMRig config example

### Alternative Overrides

The override files still exist for small behavior adjustments on top of the default Linux profile:

- [xmrig-monero/compose.linux-msr.yaml](xmrig-monero/compose.linux-msr.yaml)
- [xmrig-monero/compose.linux-hugepages.yaml](xmrig-monero/compose.linux-hugepages.yaml)

They now add environment-based tweaks and can be combined safely.

Example:

```bash
docker compose -f compose.yaml -f compose.linux-hugepages.yaml up -d xmrig
```

### Notes

- `FAILED TO APPLY MSR MOD HASHRATE WILL BE LOW` means XMRig still could not access the MSR registers at runtime.
- `HUGE PAGES supported` only means the binary supports Huge Pages. For real RandomX gains, the runtime log should show successful allocation, ideally `huge pages 100%`.
- The default Linux profile uses `privileged: true` intentionally so the published image can prepare MSR and Huge Pages without a local rebuild.
- On Docker Desktop for Windows and WSL2, MSR and 1GB Huge Pages usually remain constrained by the virtualization layer. In that setup, native Linux is the correct target for this profile.
