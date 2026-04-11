# Changelog

All notable changes to this Docker packaging project are documented here.
Each entry tracks the upstream [XMRig](https://github.com/xmrig/xmrig) version used and any packaging changes made in this repository.

## [6.26.0] - 2026-04-07

### Upstream XMRig changes
- Added support for RandomX v2 ([#3769](https://github.com/xmrig/xmrig/pull/3769), [#3772](https://github.com/xmrig/xmrig/pull/3772), [#3774](https://github.com/xmrig/xmrig/pull/3774), [#3775](https://github.com/xmrig/xmrig/pull/3775), [#3776](https://github.com/xmrig/xmrig/pull/3776), [#3782](https://github.com/xmrig/xmrig/pull/3782), [#3783](https://github.com/xmrig/xmrig/pull/3783))
- RISC-V: vectorized RandomX main loop ([#3746](https://github.com/xmrig/xmrig/pull/3746))
- RISC-V: auto-detect and use vector code for all RandomX AES functions ([#3748](https://github.com/xmrig/xmrig/pull/3748))
- RISC-V: detect and use hardware AES ([#3749](https://github.com/xmrig/xmrig/pull/3749))
- RISC-V: use vector hardware AES instead of scalar ([#3750](https://github.com/xmrig/xmrig/pull/3750))
- RISC-V: fixed scratchpad prefetch, removed unnecessary instruction ([#3757](https://github.com/xmrig/xmrig/pull/3757))
- RandomX: added VAES-512 support for Zen5 ([#3758](https://github.com/xmrig/xmrig/pull/3758))
- RandomX: optimized VAES code ([#3759](https://github.com/xmrig/xmrig/pull/3759))
- Fixed keepalive timer logic ([#3762](https://github.com/xmrig/xmrig/pull/3762))
- RandomX: ARM64 fixes ([#3778](https://github.com/xmrig/xmrig/pull/3778))
- Fixed OpenCL address-space mismatch in `keccak_f800_round` ([#3784](https://github.com/xmrig/xmrig/pull/3784))
- Don't reset nonce during donation rounds ([#3785](https://github.com/xmrig/xmrig/pull/3785))

### Packaging changes
- Added release automation workflow (`release-from-version.yml`)
- Added agent workspace guide (`AGENTS.md`)
- Added `CHANGELOG.md` with full release history
- Updated README with release automation docs and Compose usage

### Security & bug fixes (audit)
- **CRITICAL**: Fixed `docker-entrypoint.sh` using relative path `./xmrig` — now uses PATH lookup (`exec xmrig`) for compatibility with both image variants
- **CRITICAL**: Fixed broken quoting in `start_zergpool.sh` exec line
- **CRITICAL**: Fixed `start-linux-randomx.sh` hardcoded path `/home/xmrig/xmrig` — now uses `xmrig` via PATH
- **HIGH**: Removed exposed JWT example token from `config.json` (`access-token` set to `null`)
- **HIGH**: Removed `--no-check-certificate` from both Dockerfiles — TLS verification now enforced
- **HIGH**: Added `PASSWORD` env var to `Dockerfile.secure` for parity with standard image
- **HIGH**: Removed Quay.io references from CI, `build.sh`, and `README.md` (registry was not in use)
- **HIGH**: GHCR login switched from custom secrets to `github.actor` + `GITHUB_TOKEN`
- Added SHA256 checksum verification for XMRig binary downloads in both Dockerfiles
- Added `set -eu` to all shell scripts for fail-fast behavior
- Removed unused packages (`curl`, `gnupg`) from Dockerfiles
- Removed stale `docker-image.yml` workflow (triggered on non-existent `master` branch)
- Set login shell to `/usr/sbin/nologin` for container user
- Removed redundant `USER` directives in Dockerfiles
- Replaced hardcoded wallet address with `YOUR_WALLET_ADDRESS` placeholder
- Added `tls: true` to `config.json` for encrypted pool connections
- HEALTHCHECK in `Dockerfile.secure` uses `xmrig --version` via PATH instead of absolute path
- Added `.env.randomx.example` for RandomX-specific environment variables
- Extended `.dockerignore` to exclude docs and dev files from build context
- Made `security-check.sh` accept image name as parameter
- Added `github-actions` ecosystem to Dependabot configuration
- Corrected SSL/TLS claim in `SECURITY.md`
- `build.sh` now exits before security check when called with `build-only`

## [6.24.0] - 2025-07-16

### Upstream XMRig changes
- Fixed detection of L2 cache size for complex NUMA topologies ([#3671](https://github.com/xmrig/xmrig/pull/3671))
- Fixed ARMv7 build ([#3674](https://github.com/xmrig/xmrig/pull/3674))
- Fixed auto-config for AMD CPUs with less than 2 MB L3 cache per thread ([#3677](https://github.com/xmrig/xmrig/pull/3677))
- Improved IPv6 support: new defaults use IPv6 equally with IPv4 ([#3678](https://github.com/xmrig/xmrig/pull/3678))

## [6.22.2] - 2025-01-14

### Upstream XMRig changes
- See [XMRig v6.22.2 release](https://github.com/xmrig/xmrig/releases/tag/v6.22.2)

## [6.21.3] - 2024-05-14

### Upstream XMRig changes
- See [XMRig v6.21.3 release](https://github.com/xmrig/xmrig/releases/tag/v6.21.3)

## [6.21.0] - 2024-01-03

### Upstream XMRig changes
- See [XMRig v6.21.0 release](https://github.com/xmrig/xmrig/releases/tag/v6.21.0)

## [6.20.0] - 2023-07-12

### Upstream XMRig changes
- See [XMRig v6.20.0 release](https://github.com/xmrig/xmrig/releases/tag/v6.20.0)

## [6.19.2] - 2023-04-06

### Upstream XMRig changes
- See [XMRig v6.19.2 release](https://github.com/xmrig/xmrig/releases/tag/v6.19.2)

## [6.19.1] - 2023-03-29

### Upstream XMRig changes
- See [XMRig v6.19.1 release](https://github.com/xmrig/xmrig/releases/tag/v6.19.1)

## [6.19.0] - 2023-02-02

### Upstream XMRig changes
- See [XMRig v6.19.0 release](https://github.com/xmrig/xmrig/releases/tag/v6.19.0)

## [6.18.1] - 2022-11-01

### Upstream XMRig changes
- See [XMRig v6.18.1 release](https://github.com/xmrig/xmrig/releases/tag/v6.18.1)

## [6.18.0] - 2022-07-27

### Upstream XMRig changes
- See [XMRig v6.18.0 release](https://github.com/xmrig/xmrig/releases/tag/v6.18.0)

## [6.12.1] - 2021-04-27

### Upstream XMRig changes
- See [XMRig v6.12.1 release](https://github.com/xmrig/xmrig/releases/tag/v6.12.1)

## [6.8.0] - 2021-04-27

### Upstream XMRig changes
- See [XMRig v6.8.0 release](https://github.com/xmrig/xmrig/releases/tag/v6.8.0)
