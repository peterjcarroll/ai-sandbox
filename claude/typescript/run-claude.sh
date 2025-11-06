#!/bin/bash

# Build the Docker image if it doesn't exist
if ! docker image inspect claude-typescript >/dev/null 2>&1; then
    echo "Building claude-typescript image..."
    docker build -t claude-typescript "$(dirname "$0")"
fi

# Create Claude Code config directory if it doesn't exist
mkdir -p "$HOME/.config/claude-code"

# Run the container with mounted volumes
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.claude":/home/claude/.claude \
    -v "$HOME/.claude.json":/home/claude/.claude.json \
    -v "$HOME/.config/claude-code":/home/claude/.config/claude-code \
    claude-typescript
