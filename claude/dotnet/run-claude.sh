#!/bin/bash

# Parse flags
REBUILD=false
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --rebuild) REBUILD=true; shift ;;
        *) break ;;
    esac
done

# Build the Docker image if it doesn't exist or if rebuild is forced
if [ "$REBUILD" = true ] || ! docker image inspect claude-dotnet >/dev/null 2>&1; then
    echo "Building claude-dotnet image..."
    if [ "$REBUILD" = true ]; then
        docker build --pull --no-cache -t claude-dotnet "$(dirname "$0")"
    else
        docker build -t claude-dotnet "$(dirname "$0")"
    fi
fi

# Create Claude Code config directory if it doesn't exist
mkdir -p "$HOME/.config/claude-code"

# Run the container with mounted volumes
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.claude":/home/claude/.claude \
    -v "$HOME/.claude.json":/home/claude/.claude.json \
    -v "$HOME/.config/claude-code":/home/claude/.config/claude-code \
    claude-dotnet
