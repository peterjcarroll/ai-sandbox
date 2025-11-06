# Claude Code Development Containers

This repository contains Docker-based development environments for Claude Code, providing ready-to-use containers for different programming languages and frameworks.

## Available Containers

### Base Claude Container (`claude/`)
Minimal container with Claude Code CLI installed on Debian 12.

**Includes:**
- Node.js (LTS)
- npm
- Claude Code CLI

**Usage:**
```bash
cd claude
./run-claude.sh
```

### .NET Development Container (`dotnet/`)
Full-featured .NET development environment with Claude Code.

**Includes:**
- Everything from base container
- .NET 8 SDK
- Git

**Usage:**
```bash
cd dotnet
chmod +x run-claude.sh
./run-claude.sh
```

### Python Development Container (`python/`)
Python development environment with Claude Code.

**Includes:**
- Everything from base container
- Python 3 (Debian 12 default version)
- pip
- python-venv
- build-essential (for compiling Python packages)
- Git

**Usage:**
```bash
cd python
chmod +x run-claude.sh
./run-claude.sh
```

### TypeScript Development Container (`typescript/`)
TypeScript and Node.js development environment with Claude Code.

**Includes:**
- Everything from base container
- TypeScript compiler (tsc)
- ts-node
- @types/node
- Git

**Usage:**
```bash
cd typescript
chmod +x run-claude.sh
./run-claude.sh
```

## How It Works

Each container:
1. Builds automatically on first run (if not already built)
2. Mounts your current directory to `/workspace` inside the container
3. Preserves your Claude Code configuration via mounted volumes
4. Runs as a non-root user for security
5. Starts Claude Code CLI automatically

## Volume Mounts

All containers mount the following:
- `$(pwd)` → `/workspace` - Your current working directory
- `~/.claude` → `/home/claude/.claude` - Claude authentication
- `~/.claude.json` → `/home/claude/.claude.json` - Claude config file
- `~/.config/claude-code` → `/home/claude/.config/claude-code` - Claude Code settings

## Rebuilding Containers

To rebuild a container (e.g., after updating the Dockerfile):

```bash
# For .NET container
docker build -t claude-dotnet dotnet/

# For Python container
docker build -t claude-python python/

# For TypeScript container
docker build -t claude-typescript typescript/

# For base container
docker build -t claude-dev claude/
```

## Running Containers Manually

You can also run containers manually with custom settings:

```bash
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.claude":/home/claude/.claude \
    -v "$HOME/.claude.json":/home/claude/.claude.json \
    -v "$HOME/.config/claude-code":/home/claude/.config/claude-code \
    claude-dotnet  # or claude-python, claude-typescript, claude-dev
```

## Requirements

- Docker installed and running
- Claude Code authentication token (set up via `claude` command)

## License

MIT
