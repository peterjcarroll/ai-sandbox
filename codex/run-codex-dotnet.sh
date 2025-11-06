#!/bin/bash

# Build the Docker image if it doesn't exist
if ! docker image inspect codex-dotnet >/dev/null 2>&1; then
    echo "Building codex-dotnet image..."
    docker build -t codex-dotnet "$(dirname "$0")/dotnet"
fi

# Create OpenAI config directory if it doesn't exist
mkdir -p "$HOME/.openai"

# Run the container with mounted volumes
# Note: Set OPENAI_API_KEY environment variable before running
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.openai":/home/codex/.openai \
    -e OPENAI_API_KEY \
    codex-dotnet
