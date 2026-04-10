---
mode: "agent"
description: "Create a new xmrig-monero release: optionally check for new upstream XMRig versions, bump versions, update CHANGELOG.md with upstream changes, then tag and publish a GitHub release."
---

Create a release for this repository.

## Workflow

1. **Version input.** If no version is provided in the request, ask for it (format `6.27.0` or `v6.27.0`).
2. **Normalize** to `VERSION` (without `v`) and `TAG` (`v${VERSION}`).
3. **Fetch upstream XMRig release notes** from `https://github.com/xmrig/xmrig/releases/tag/v${VERSION}` using `gh release view v${VERSION} --repo xmrig/xmrig --json body -q .body`. Extract the changelog items (bug fixes, features, improvements) — ignore SHA256 checksums and GPG signatures.
4. **Update `CHANGELOG.md`**: add a new section at the top (below the header) with:
   - `## [${VERSION}] - ${YYYY-MM-DD}` (today's date)
   - `### Upstream XMRig changes` — list items from step 3
   - `### Packaging changes` — list any packaging changes made in this release (if any)
5. **Update version references** in these files:
   - `Dockerfile` → `ARG VERSION_TAG=${VERSION}`
   - `Dockerfile.secure` → `ARG VERSION_TAG=${VERSION}`
   - `build.sh` → `version="${VERSION}"`
   - `README.md` → three backtick-quoted version strings under "Version Notes"
   - `SECURITY.md` → supported `major.minor.x` row
6. **Validate** with:
   - `docker build . -t cniweb/xmrig:test --file Dockerfile`
   - `docker build . -t cniweb/xmrig:secure --file Dockerfile.secure`
7. **Commit** using message: `chore(release): ${TAG}`
8. **Create and push** Git tag `${TAG}`.
9. **Create a GitHub release** with title/body based on the latest previous release text, replacing old tag/version with the new one. Include a summary of upstream changes in the release body.
10. **Report** exactly which files changed and final tag/release URL.

Prefer using the workflow `Create Release From Version` (`.github/workflows/release-from-version.yml`) when possible. The workflow handles steps 5, 7, 8, and 9 automatically but does **not** update `CHANGELOG.md` — that must be done manually or by the agent before running the workflow.

## Checking for new upstream versions

When asked to check for a new XMRig version:

1. Run `gh release list --repo xmrig/xmrig --limit 5` to find the latest release.
2. Compare with the current version in `Dockerfile` (`ARG VERSION_TAG=...`).
3. If a newer version exists, report it and ask whether to proceed with the release workflow above.
