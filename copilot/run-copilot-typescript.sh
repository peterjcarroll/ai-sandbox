#!/bin/bash

# Build the Docker image if it doesn't exist
if ! docker image inspect copilot-typescript >/dev/null 2>&1; then
    echo "Building copilot-typescript image..."
    docker build -t copilot-typescript "$(dirname "$0")/typescript"
fi

# Create GitHub Copilot config directory if it doesn't exist
mkdir -p "$HOME/.config/github-copilot"

# Run the container with mounted volumes
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.config/github-copilot":/home/copilot/.config/github-copilot \
    copilot-typescript
