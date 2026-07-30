## Summary

<!-- What does this PR change and why? -->

## Checklist

- [ ] If this is an XMRig version bump: all six files are in sync (`Dockerfile`, `Dockerfile.secure`, `build.sh`, `README.md`, `SECURITY.md`, `CHANGELOG.md`) — prefer using `release-from-version.yml` instead of editing these by hand.
- [ ] `CHANGELOG.md` has an `## [Unreleased]` entry describing this change (required before the release workflow can run).
- [ ] Shell scripts (`*.sh`) stay POSIX-compatible (`set -eu`, no bashisms) if touched.
- [ ] Ran `docker build . --file Dockerfile` and `docker build . --file Dockerfile.secure` locally, or relied on CI's `validate` job.
- [ ] Updated `AGENTS.md` / `.github/copilot-instructions.md` if this changes repo conventions, CI behavior, or known gotchas.

## Testing

<!-- How did you verify this change? Include commands/output where useful. -->
