# Agent Workspace Guide

This file exists so agentic AI tools that discover AGENTS.md can load workspace guidance.

Primary instruction source:

- [.github/copilot-instructions.md](.github/copilot-instructions.md)

If guidance here and in the copilot instructions differ, treat [.github/copilot-instructions.md](.github/copilot-instructions.md) as canonical and update this file to match.

## Quick Start

1. Read [.github/copilot-instructions.md](.github/copilot-instructions.md) first.
2. For runtime and platform details, read [README.md](README.md).
3. For security policy and reporting, read [SECURITY.md](SECURITY.md).

## Mandatory Project Rules

- Keep XMRig version synchronized across [Dockerfile](Dockerfile), [Dockerfile.secure](Dockerfile.secure), [build.sh](build.sh), and [README.md](README.md).
- Preserve shell script style in this repo (POSIX-friendly syntax and explicit error handling).
- Prefer environment-driven runtime configuration over hardcoded values.
- Use port 8080 consistently.
- MSR and 1GB huge pages require host-level Linux capabilities and are not expected to work in Azure Container Instances or Docker Desktop with WSL2.

## Validation Commands

- docker build . -t cniweb/xmrig:test --file Dockerfile
- docker build . -t cniweb/xmrig:secure --file Dockerfile.secure
- ./build.sh build-only
- docker run --rm cniweb/xmrig:test --version
- docker run --rm cniweb/xmrig:test --dry-run
- ./security-check.sh
