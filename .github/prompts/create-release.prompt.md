---
mode: "agent"
description: "Create a new xmrig-monero release: ask for version if missing, bump versions in Dockerfiles/build.sh/docs, then tag and publish a GitHub release."
---

Create a release for this repository.

Workflow:
1. If no version is provided in the request, ask for it first (format `6.26.0` or `v6.26.0`).
2. Normalize to:
   - `VERSION` (without `v`)
   - `TAG` (`v${VERSION}`)
3. Update version references in these files:
   - `Dockerfile` (`ARG VERSION_TAG=...`)
   - `Dockerfile.secure` (`ARG VERSION_TAG=...`)
   - `build.sh` (`version="..."`)
   - `README.md` (version notes)
   - `SECURITY.md` (supported major.minor.x row)
4. Validate with:
   - `docker build . -t cniweb/xmrig:test --file Dockerfile`
   - `docker build . -t cniweb/xmrig:secure --file Dockerfile.secure`
5. Commit changes using:
   - `chore(release): ${TAG}`
6. Create and push Git tag `${TAG}`.
7. Create a GitHub release with title/body based on the latest previous release text, replacing only old tag/version with the new one.
8. Report exactly which files changed and final tag/release URL.

Prefer using the workflow `Create Release From Version` (`.github/workflows/release-from-version.yml`) when possible.
