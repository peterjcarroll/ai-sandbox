# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository provides Docker-based development environments for various AI coding assistants (Claude Code, GitHub Copilot, OpenAI Codex). Each environment is language-specific (base, .NET, Python, TypeScript) and follows a consistent architecture pattern.

## Repository Structure

The repository is organized into three main directories, each containing similar language-specific subdirectories:

- `claude/` - Claude Code containers
- `copilot/` - GitHub Copilot containers
- `codex/` - OpenAI Codex containers

Each directory contains:
- Base `Dockerfile` and `run-*.sh` script for minimal container
- `dotnet/`, `python/`, `typescript/` subdirectories with language-specific Dockerfiles
- Top-level convenience scripts that reference subdirectories (e.g., `run-claude-python.sh`)

## Building and Running Containers

### Quick Start Commands

Run any container using the appropriate script from the repository root:

```bash
# Claude containers
./claude/run-claude.sh                    # Base (Node.js only)
./claude/run-claude-python.sh             # Python environment
./claude/run-claude-dotnet.sh             # .NET environment
./claude/run-claude-typescript.sh         # TypeScript environment

# GitHub Copilot containers
./copilot/run-copilot.sh                  # Base
./copilot/run-copilot-python.sh
./copilot/run-copilot-dotnet.sh
./copilot/run-copilot-typescript.sh

# OpenAI Codex containers
./codex/run-codex.sh                      # Base
./codex/run-codex-python.sh
./codex/run-codex-dotnet.sh
./codex/run-codex-typescript.sh
```

### Rebuilding Images

All run scripts support a `--rebuild` flag to force rebuild with no cache:

```bash
./claude/run-claude-python.sh --rebuild
./copilot/run-copilot-typescript.sh --rebuild
```

Manual rebuild commands for each image:

```bash
# Claude images
docker build -t claude-dev claude/
docker build -t claude-python claude/python/
docker build -t claude-dotnet claude/dotnet/
docker build -t claude-typescript claude/typescript/

# Copilot images
docker build -t copilot-dev copilot/
docker build -t copilot-python copilot/python/
docker build -t copilot-dotnet copilot/dotnet/
docker build -t copilot-typescript copilot/typescript/

# Codex images
docker build -t codex-dev codex/
docker build -t codex-python codex/python/
docker build -t codex-dotnet codex/dotnet/
docker build -t codex-typescript codex/typescript/
```

## Architecture Patterns

### Dockerfile Structure

All Dockerfiles follow a consistent pattern:

1. Start from `debian:12-slim` base image
2. Install core dependencies (curl, ca-certificates, gnupg, git if needed)
3. Install Node.js LTS via NodeSource repository
4. Install language-specific tools (Python, .NET SDK, TypeScript, etc.)
5. Install AI assistant CLI globally via npm
6. Create non-root user (claude/copilot/codex) with UID 1000
7. Set `/workspace` as working directory
8. Run CLI tool with appropriate flags

### Run Script Pattern

All run scripts follow this pattern:

1. Parse `--rebuild` flag
2. Check if Docker image exists, build if missing or rebuild forced
3. Create necessary config directories in `$HOME`
4. Run container with:
   - `-it --rm` flags (interactive, auto-remove)
   - Current directory mounted to `/workspace`
   - Config directories mounted to preserve authentication/settings
   - Image name matching the AI assistant

### Volume Mounts

**Claude containers** mount:
- `$(pwd)` → `/workspace`
- `~/.claude` → `/home/claude/.claude`
- `~/.claude.json` → `/home/claude/.claude.json`
- `~/.config/claude-code` → `/home/claude/.config/claude-code`

**Copilot containers** mount:
- `$(pwd)` → `/workspace`
- `~/.copilot` → `/home/copilot/.copilot`

**Codex containers** mount:
- `$(pwd)` → `/workspace`
- `~/.codex` → `/home/codex/.codex`

### CLI Entry Points

Each container runs its respective CLI automatically:

- Claude: `claude --dangerously-skip-permissions`
- Copilot: `copilot --allow-all-tools`
- Codex: `codex --dangerously-bypass-approvals-and-sandbox`

## Language-Specific Details

### .NET Containers
- Install .NET 8 SDK via dotnet-install.sh script
- Set `DOTNET_ROOT=/usr/share/dotnet`
- Symlink dotnet binary to `/usr/bin/dotnet`

### Python Containers
- Install python3, pip, venv, build-essential for package compilation
- Create symlinks: `/usr/bin/python` → `python3`, `/usr/bin/pip` → `pip3`

### TypeScript Containers
- Install TypeScript, ts-node, @types/node globally via npm

## Adding New Containers

When adding a new language or AI assistant variant:

1. Create subdirectory with Dockerfile following the standard pattern
2. Create run script in parent directory (e.g., `run-claude-{language}.sh`)
3. Update image name to match pattern: `{assistant}-{language}`
4. Ensure non-root user matches the assistant name
5. Mount appropriate config directories for authentication
6. Update README.md with new container information
