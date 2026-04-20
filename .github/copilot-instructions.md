# Project Guidelines

## Code Style
- Keep Dockerfiles and shell scripts minimal and explicit.
- Preserve existing shell style (`set -eu`, POSIX-friendly syntax) in `*.sh` files.
- Prefer environment-driven runtime configuration over hardcoded values.

## Architecture
- This repository packages prebuilt XMRig binaries into container images.
- Runtime paths:
	- Direct image run: non-root defaults from `Dockerfile` + `config.json`.
	- Linux performance profile: `compose.yaml` + `start-linux-randomx.sh` with elevated runtime privileges.
- Key files:
	- `Dockerfile`, `Dockerfile.secure`: image definitions.
	- `docker-entrypoint.sh`: image default startup logic.
	- `compose.yaml`: Linux RandomX runtime profile.
	- `build.sh`: build, tag, and push workflow.

## Build and Test
- Standard build: `docker build . -t cniweb/xmrig:test --file Dockerfile`
- Secure build: `docker build . -t cniweb/xmrig:secure --file Dockerfile.secure`
- Build helper: `./build.sh build-only`
- Validate image: `docker run --rm cniweb/xmrig:test --version`
- Validate config: `docker run --rm cniweb/xmrig:test --dry-run`
- Security checks: `./security-check.sh`

## Conventions
- Keep XMRig version synchronized across all six files: `Dockerfile`, `Dockerfile.secure`, `build.sh`, `README.md`, `SECURITY.md`, and `CHANGELOG.md`. The release workflow handles the first five automatically; `CHANGELOG.md` must be updated manually.
- Use port `8080` consistently.
- MSR and 1GB huge pages require host-level Linux capabilities; they are not expected to work in Azure Container Instances or Docker Desktop/WSL2.
- For releases, prefer workflow `.github/workflows/release-from-version.yml` and keep `SECURITY.md` supported-version row in sync.
- Do not duplicate long docs in instructions; reference:
	- `README.md` for runtime usage and Azure VM commands.
	- `SECURITY.md` for security policy and reporting.