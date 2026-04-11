# Agent Workspace Guide

Primary instruction source: [.github/copilot-instructions.md](.github/copilot-instructions.md) (canonical when it conflicts with this file).

## What this repo is

Docker packaging for prebuilt XMRig binaries. No source compilation — Dockerfiles download release tarballs from `github.com/xmrig/xmrig`. There are two image variants:

- `Dockerfile` — single-stage, standard image.
- `Dockerfile.secure` — multi-stage build; binary ends up at `/usr/local/bin/xmrig` (not in the workdir). Includes a HEALTHCHECK.

Runtime entrypoint is `docker-entrypoint.sh`. The Compose profile (`compose.yaml`) uses a separate script `start-linux-randomx.sh` instead.

## Version sync (critical)

When changing the XMRig version, update **all six** files — the release workflow (`release-from-version.yml`) handles five automatically, but `CHANGELOG.md` must be updated manually or by the agent:

| File | Pattern |
|---|---|
| `Dockerfile` | `ARG VERSION_TAG=X.Y.Z` |
| `Dockerfile.secure` | `ARG VERSION_TAG=X.Y.Z` |
| `build.sh` | `version="X.Y.Z"` |
| `README.md` | three backtick-quoted version strings under "Version Notes" |
| `SECURITY.md` | supported-version table row (`X.Y.x`) |
| `CHANGELOG.md` | new section at top with upstream changes and packaging changes |

For automated releases, use workflow `.github/workflows/release-from-version.yml` or prompt `.github/prompts/create-release.prompt.md`.

## Checking for new upstream versions

When asked to check for a new XMRig version:

1. Run `gh release list --repo xmrig/xmrig --limit 5` to find the latest upstream release.
2. Compare with the current version in `Dockerfile` (`ARG VERSION_TAG=...`).
3. If newer, fetch upstream release notes: `gh release view v${VERSION} --repo xmrig/xmrig --json body -q .body`
4. Extract changelog items (ignore SHA256 checksums and GPG signatures).
5. Follow the full release workflow in `.github/prompts/create-release.prompt.md`.

## Validation commands

```sh
docker build . -t cniweb/xmrig:test --file Dockerfile
docker build . -t cniweb/xmrig:secure --file Dockerfile.secure
./build.sh build-only
docker run --rm cniweb/xmrig:test --version
docker run --rm cniweb/xmrig:test --dry-run
./security-check.sh          # requires cniweb/xmrig:test image to exist
```

## Shell script conventions

- `docker-entrypoint.sh` and `start-linux-randomx.sh` use `/bin/sh` with `set -eu` — keep them POSIX-compatible (no bashisms).
- `build.sh` and `security-check.sh` use `#!/bin/bash`.
- Prefer environment-driven runtime config over hardcoded values.

## CI

- Push to `main` triggers `.github/workflows/docker-build.yml` which builds and pushes to Docker Hub and GHCR.
- Snyk container scanning runs via `snyk-container-analysis.yml`.
- Dependabot monitors Docker base images and GitHub Actions versions.

## Conventions

- Always use port **8080** (non-privileged).
- MSR and 1GB huge pages require host-level Linux capabilities; they do not work in Azure Container Instances or Docker Desktop with WSL2.
- Container runs as non-root user `xmrig` (uid 1000) by default; root is only needed for MSR/huge-pages features.
