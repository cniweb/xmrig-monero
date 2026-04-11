# XMRig

![XMRig](https://avatars0.githubusercontent.com/u/27528955?s=460&u=555699fb82e7598ed7dd1f6e47302042b48a10c3&v=4)

High performance, open source RandomX, CryptoNight, AstroBWT and Argon2 CPU/GPU miner Docker image.

[![Build & Push Docker Image](https://github.com/cniweb/xmrig-monero/actions/workflows/docker-build.yml/badge.svg)](https://github.com/cniweb/xmrig-monero/actions/workflows/docker-build.yml) [![Snyk Container](https://github.com/cniweb/xmrig-monero/actions/workflows/snyk-container-analysis.yml/badge.svg)](https://github.com/cniweb/xmrig-monero/actions/workflows/snyk-container-analysis.yml) ![Docker Pulls](https://img.shields.io/docker/pulls/cniweb/xmrig)

## Available Container Registries

This image is published to multiple registries.

### Docker Hub

```bash
docker run docker.io/cniweb/xmrig:latest
```

### GitHub Container Registry

```bash
docker run ghcr.io/cniweb/xmrig:latest
```

Package link: <https://github.com/cniweb/xmrig-monero/pkgs/container/xmrig>

## Version Notes

- `Dockerfile` currently uses XMRig `6.26.0`.
- `build.sh` currently tags/pushes `6.26.0`.
- `Dockerfile.secure` currently uses XMRig `6.26.0`.

## Release Automation

This repository includes a manual GitHub workflow to create a new release from a version input:

- Workflow: `.github/workflows/release-from-version.yml`
- Trigger: GitHub Actions -> `Create Release From Version` -> `Run workflow`
- Input: `version` (`6.27.0` or `v6.27.0`)

What it does:

1. Updates version references in `Dockerfile`, `Dockerfile.secure`, `build.sh`, `README.md`, and `SECURITY.md`
2. Creates a commit (`chore(release): vX.Y.Z`)
3. Creates and pushes git tag `vX.Y.Z`
4. Creates a GitHub release by reusing previous release title/body and replacing only the version/tag

For agent-driven release requests, use prompt file:

- `.github/prompts/create-release.prompt.md`

## Default Image Behavior (docker run)

Direct `docker run` uses:

- bundled `config.json` (GhostRider defaults)
- non-root user `xmrig`
- entrypoint `docker-entrypoint.sh`

Example:

```bash
docker run --rm ghcr.io/cniweb/xmrig:latest --version
```

MSR and 1GB huge pages are not enabled automatically in this default non-root mode.

## Linux Compose Profile (RandomX)

`compose.yaml` is a Linux-focused RandomX runtime profile that runs the published image with elevated runtime permissions and a startup helper script.

Usage:

```bash
cp .env.randomx.example .env
docker compose up -d xmrig
```

Main files:

- `compose.yaml`
- `start-linux-randomx.sh`
- `.env.randomx.example`
- `config.randomx.json` (standalone RandomX config example)

Optional overrides:

- `compose.linux-msr.yaml`
- `compose.linux-hugepages.yaml`

Example with override:

```bash
docker compose -f compose.yaml -f compose.linux-hugepages.yaml up -d xmrig
```

## Azure VM (Linux): docker run with MSR + Huge Pages

If you run on a native Linux Azure VM (not ACI), prepare host settings first:

```bash
sudo modprobe msr
sudo modprobe msr allow_writes=on
sudo sysctl -w vm.nr_hugepages="$(nproc)"
for i in /sys/devices/system/node/node*; do
  echo 3 | sudo tee "$i/hugepages/hugepages-1048576kB/nr_hugepages" >/dev/null
done
```

Then run:

```bash
docker run -d \
  --name xmrig \
  --restart unless-stopped \
  --user root \
  --privileged \
  --cap-add=SYS_RAWIO \
  --cap-add=IPC_LOCK \
  --device=/dev/cpu:/dev/cpu \
  --ulimit memlock=-1:-1 \
  -p 8080:8080 \
  -e XMRIG_MSR=1 \
  -e XMRIG_HUGE_PAGES_JIT=1 \
  -e XMRIG_RANDOMX_1GB_PAGES=1 \
  -e ALGO=rx/0 \
  -e POOL_ADDRESS='stratum+ssl://pool.supportxmr.com:443' \
  -e WALLET_USER='YOUR_MONERO_WALLET.worker' \
  -e PASSWORD='x' \
  ghcr.io/cniweb/xmrig:latest
```

Check runtime status:

```bash
docker logs -f xmrig
```

## Azure Container Instances Limitation

Azure Container Instances does not expose the host-level interfaces required for MSR and 1GB huge pages.

Typical ACI log messages:

- `msr kernel module is not available`
- `FAILED TO APPLY MSR MOD, HASHRATE WILL BE LOW`
- `1GB PAGES disabled`

For MSR and huge pages tuning, use a native Linux VM runtime.

## Notes

- `HUGE PAGES supported` means binary support exists, not that allocation succeeded.
- For real gains, XMRig should report high huge pages allocation (ideally near `100%`).
- On Docker Desktop with WSL2, MSR and 1GB huge pages are often constrained by virtualization.
