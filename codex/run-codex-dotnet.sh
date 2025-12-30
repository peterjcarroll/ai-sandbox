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
if [ "$REBUILD" = true ] || ! docker image inspect codex-dotnet >/dev/null 2>&1; then
    echo "Building codex-dotnet image..."
    if [ "$REBUILD" = true ]; then
        docker build --pull --no-cache -t codex-dotnet "$(dirname "$0")/dotnet"
    else
        docker build -t codex-dotnet "$(dirname "$0")/dotnet"
    fi
fi

# Create OpenAI config directory if it doesn't exist
mkdir -p "$HOME/.codex"

# Run the container with mounted volumes
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.codex":/home/codex/.codex \
    codex-dotnet
