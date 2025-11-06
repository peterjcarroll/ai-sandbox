#!/bin/bash

# Build the Docker image if it doesn't exist
if ! docker image inspect codex-python >/dev/null 2>&1; then
    echo "Building codex-python image..."
    docker build -t codex-python "$(dirname "$0")/python"
fi

# Create OpenAI config directory if it doesn't exist
mkdir -p "$HOME/.openai"

# Run the container with mounted volumes
# Note: Set OPENAI_API_KEY environment variable before running
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.openai":/home/codex/.openai \
    -e OPENAI_API_KEY \
    codex-python
