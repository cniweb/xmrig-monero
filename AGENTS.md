# Agent Workspace Guide

Primary instruction source: `.github/copilot-instructions.md` (canonical when it conflicts with this file).

## Repo shape

- This repo packages prebuilt XMRig release tarballs; it does not build XMRig from source.
- `Dockerfile` is the standard image. `Dockerfile.secure` is the multi-stage variant; its binary is copied to `/usr/local/bin/xmrig`, so runtime scripts must use `xmrig` via `PATH`, not `./xmrig`.
- Default `docker run` uses `docker-entrypoint.sh`. `compose.yaml` does **not** use that entrypoint; it replaces it with `/opt/xmrig/start-linux-randomx.sh` mounted from the repo.

## Verification

- Primary checks are Docker-based:
  - `docker build . -t cniweb/xmrig:test --file Dockerfile`
  - `docker build . -t cniweb/xmrig:secure --file Dockerfile.secure`
  - `docker run --rm cniweb/xmrig:test --version`
  - `docker run --rm cniweb/xmrig:test --dry-run`
- `./build.sh build-only` is the same build path CI uses on `main`; it exits before security checks or pushes.
- `./security-check.sh` defaults to image `cniweb/xmrig:test`; build that tag first or pass a different image name.

## Shell and runtime constraints

- `docker-entrypoint.sh`, `start-linux-randomx.sh`, and `start_zergpool.sh` are `sh` scripts with `set -eu`; keep them POSIX-compatible.
- Port `8080` is the expected HTTP/API port across Dockerfiles, compose, docs, and checks.
- The image runs as non-root `xmrig` by default. MSR and 1GB huge pages only work in the root/elevated Linux profile.
- `compose.yaml` is a Linux host profile that runs `privileged`, mounts `/dev/cpu`, and writes huge-page/MSR settings from inside the container. Do not assume it will work on Docker Desktop/WSL2 or Azure Container Instances.

## Release/versioning

- XMRig version bumps must stay synchronized across all six files: `Dockerfile`, `Dockerfile.secure`, `build.sh`, `README.md`, `SECURITY.md`, and `CHANGELOG.md`.
- The release workflow (`.github/workflows/release-from-version.yml`) handles the first five automatically but **does not** update `CHANGELOG.md` — that must be done manually or by the agent before triggering it.
- Prefer that workflow for releases: it updates version refs, commits, tags `vX.Y.Z`, and creates the GitHub release.
- When checking for a new upstream version, compare `Dockerfile`'s `ARG VERSION_TAG` against `gh release list --repo xmrig/xmrig --limit 5`, then fetch notes with `gh release view v${VERSION} --repo xmrig/xmrig --json body -q .body`.

## Small gotchas

- `.dockerignore` excludes docs, compose files, `build.sh`, and `security-check.sh`; changes there do not affect image build context.
- The Linux compose overrides only tweak env vars: `compose.linux-msr.yaml` sets `XMRIG_NO_RDMSR=1`, and `compose.linux-hugepages.yaml` sets `XMRIG_RANDOMX_MODE=fast`.

## CI

- Push to `main` triggers `.github/workflows/docker-build.yml`: builds with `./build.sh build-only`, then tags and pushes versioned + `latest` + commit-SHA tags to Docker Hub and GHCR.
- Snyk container scanning runs on push/PR to `main` and weekly via `snyk-container-analysis.yml`.
- Dependabot monitors Docker base images and GitHub Actions versions.
