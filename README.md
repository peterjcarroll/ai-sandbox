# AI Development Containers

This repository contains Docker-based development environments for various AI coding assistants, providing ready-to-use containers for different programming languages and frameworks.

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

### GitHub Copilot Container (`copilot/`)
Development environment with GitHub Copilot CLI.

**Includes:**
- Node.js (LTS)
- npm
- GitHub Copilot CLI
- Git

**Usage:**
```bash
cd copilot
chmod +x run-copilot.sh
./run-copilot.sh
```

**Note:** You'll need to authenticate with GitHub Copilot on first run.

### OpenAI Codex Container (`codex/`)
Development environment with OpenAI SDK for accessing Codex API.

**Includes:**
- Node.js (LTS)
- Python 3
- OpenAI Python SDK
- OpenAI Node.js SDK
- pip & npm
- Git

**Usage:**
```bash
cd codex
chmod +x run-codex.sh
export OPENAI_API_KEY="your-api-key-here"
./run-codex.sh
```

**Note:** Requires an OpenAI API key set in the `OPENAI_API_KEY` environment variable.

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

# For Copilot container
docker build -t copilot-dev copilot/

# For Codex container
docker build -t codex-dev codex/

# For base container
docker build -t claude-dev claude/
```

## Running Containers Manually

You can also run containers manually with custom settings:

```bash
# Claude containers
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.claude":/home/claude/.claude \
    -v "$HOME/.claude.json":/home/claude/.claude.json \
    -v "$HOME/.config/claude-code":/home/claude/.config/claude-code \
    claude-dotnet  # or claude-python, claude-typescript, claude-dev

# Copilot container
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.config/github-copilot":/home/copilot/.config/github-copilot \
    copilot-dev

# Codex container
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.openai":/home/codex/.openai \
    -e OPENAI_API_KEY \
    codex-dev
```

## Requirements

- Docker installed and running
- For Claude containers: Claude Code authentication token (set up via `claude` command)
- For Copilot container: GitHub Copilot subscription and authentication
- For Codex container: OpenAI API key with Codex access

## License

MIT
