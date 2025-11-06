#!/bin/bash

# Build the Docker image if it doesn't exist
if ! docker image inspect codex-typescript >/dev/null 2>&1; then
    echo "Building codex-typescript image..."
    docker build -t codex-typescript "$(dirname "$0")/typescript"
fi

# Create OpenAI config directory if it doesn't exist
mkdir -p "$HOME/.openai"

# Run the container with mounted volumes
# Note: Set OPENAI_API_KEY environment variable before running
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.openai":/home/codex/.openai \
    -e OPENAI_API_KEY \
    codex-typescript
