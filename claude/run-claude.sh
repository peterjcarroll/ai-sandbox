#!/bin/bash

# Build the Docker image if it doesn't exist
if ! docker image inspect claude-dev >/dev/null 2>&1; then
    echo "Building claude-dev image..."
    docker build -t claude-dev "$(dirname "$0")"
fi

# Run the container with mounted volumes
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.claude":/home/claude/.claude \
    -v "$HOME/.claude.json":/home/claude/.claude.json \
    claude-dev
