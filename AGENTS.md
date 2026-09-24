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
- The release workflow (`.github/workflows/release-from-version.yml`) handles all six automatically: it updates version refs in the first five, and promotes `CHANGELOG.md`'s `## [Unreleased]` heading to `## [<version>] - <date>`. **The workflow fails fast if `CHANGELOG.md` has no `## [Unreleased]` section** — add one with the release notes before triggering it.
- Prefer that workflow for releases: it updates version refs, commits, tags `vX.Y.Z`, and creates the GitHub release.
- When checking for a new upstream version, compare `Dockerfile`'s `ARG VERSION_TAG` against `gh release list --repo xmrig/xmrig --limit 5`, then fetch notes with `gh release view v${VERSION} --repo xmrig/xmrig --json body -q .body`.

## Small gotchas

- xmrig resolves a relative `config.json` against the binary's own path, not the working directory. `docker-entrypoint.sh` injects an explicit `--config=<abs path>` unless the caller already passed `-c`/`--config`; do not remove that shim, especially for `Dockerfile.secure` (binary at `/usr/local/bin`, config at `/home/xmrig`).
- `.dockerignore` excludes docs, compose files, `build.sh`, and `security-check.sh`; changes there do not affect image build context.
- The Linux compose overrides only tweak env vars: `compose.linux-msr.yaml` sets `XMRIG_NO_RDMSR=1`, and `compose.linux-hugepages.yaml` sets `XMRIG_RANDOMX_MODE=fast`.
- Docker builds download GitHub release assets and therefore require network access. The bundled release is the static Linux x64 build; non-x86 hosts require explicit compatibility planning.
- `./build.sh build-only` still builds and tags Docker Hub-style local tags; it does not build a registry-neutral tag. Use `docker compose config` to validate compose changes.
- `docker-entrypoint.sh` intentionally exits when MSR or 1GB-page options are requested without the required root/device access. `--version` and `--dry-run` validate startup only, not pool connectivity or hashrate.
- Compose `API_PORT` changes the host mapping and XMRig HTTP port; the image convention remains port `8080`.

## Release checklist

- Keep all six version locations synchronized: `Dockerfile`, `Dockerfile.secure`, `build.sh`, `README.md`, `SECURITY.md`, and `CHANGELOG.md`.
- Ensure `CHANGELOG.md` contains `## [Unreleased]` before running the release workflow.
- Recheck `security-check.sh` whenever image paths change; it assumes the standard image layout.

## CI

- `.github/workflows/docker-build.yml` runs on push and PR to `main`:
  - `validate` job (matrix over `Dockerfile` and `Dockerfile.secure`): builds each with `./build.sh build-only`, then runs `--version`, `--dry-run`, and `security-check.sh` against it. Never pushes.
  - `docker` job (push events only, gated on `validate` passing): rebuilds `Dockerfile`, re-runs the same validation against the exact image about to ship, then tags and pushes versioned + `latest` + commit-SHA tags to Docker Hub and GHCR, and generates a SLSA provenance attestation.
  - `Dockerfile.secure` is validated on every push/PR but is not pushed to any registry.
- Snyk container scanning runs on push/PR to `main` and weekly via `snyk-container-analysis.yml`.
- Dependabot monitors Docker base images and GitHub Actions versions.

## Lessons learned

- Merge Dependabot PRs oldest-first after checking `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`, and green checks (`gh pr view <n> --json mergeable,mergeStateStatus,statusCheckRollup`); use merge commits (repo convention), then verify the queue is empty.
- If local `main` is behind `origin/main`: stash uncommitted work, `git pull --ff-only`, re-apply the stash, and commit only the scoped files.
- Committed docs must not hard-depend on gitignored local paths — mark them local-only. Assistant config (`.claude/`, `.serena/`, `CLAUDE.md`) is gitignored and absent on fresh clones.
- Self-improvement: when a session surfaces a repo gotcha, add it here so this file keeps improving.

<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **xmrig-monero** (32 symbols, 18 relationships, 0 execution flows). Use the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> If any GitNexus tool warns the index is stale, run `npx gitnexus analyze` in terminal first.
> Always pass `repo: "xmrig-monero"` explicitly — several repos share this index and calls fail without it.
> If `gitnexus analyze` fails with an FTS/Binder extension error, don't block on it; fall back to grep/glob + direct reads.

## Always Do

- **MUST run impact analysis before editing any symbol.** Before modifying a function, class, or method, run `gitnexus_impact({target: "symbolName", direction: "upstream"})` and report the blast radius (direct callers, affected processes, risk level) to the user.
- **MUST run `gitnexus_detect_changes()` before committing** to verify your changes only affect expected symbols and execution flows.
- **MUST warn the user** if impact analysis returns HIGH or CRITICAL risk before proceeding with edits.
- When exploring unfamiliar code, use `gitnexus_query({query: "concept"})` to find execution flows instead of grepping. It returns process-grouped results ranked by relevance.
- When you need full context on a specific symbol — callers, callees, which execution flows it participates in — use `gitnexus_context({name: "symbolName"})`.

## Never Do

- NEVER edit a function, class, or method without first running `gitnexus_impact` on it.
- NEVER ignore HIGH or CRITICAL risk warnings from impact analysis.
- NEVER rename symbols with find-and-replace — use `gitnexus_rename` which understands the call graph.
- NEVER commit changes without running `gitnexus_detect_changes()` to check affected scope.

## Resources

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/xmrig-monero/context` | Codebase overview, check index freshness |
| `gitnexus://repo/xmrig-monero/clusters` | All functional areas |
| `gitnexus://repo/xmrig-monero/processes` | All execution flows |
| `gitnexus://repo/xmrig-monero/process/{name}` | Step-by-step execution trace |

## CLI

Skill files below live under gitignored `.claude/` — they exist only in local assistant workspaces, not on fresh clones.

| Task | Read this skill file |
|------|---------------------|
| Understand architecture / "How does X work?" | `.claude/skills/gitnexus/gitnexus-exploring/SKILL.md` |
| Blast radius / "What breaks if I change X?" | `.claude/skills/gitnexus/gitnexus-impact-analysis/SKILL.md` |
| Trace bugs / "Why is X failing?" | `.claude/skills/gitnexus/gitnexus-debugging/SKILL.md` |
| Rename / extract / split / refactor | `.claude/skills/gitnexus/gitnexus-refactoring/SKILL.md` |
| Tools, resources, schema reference | `.claude/skills/gitnexus/gitnexus-guide/SKILL.md` |
| Index, status, clean, wiki CLI commands | `.claude/skills/gitnexus/gitnexus-cli/SKILL.md` |

<!-- gitnexus:end -->
