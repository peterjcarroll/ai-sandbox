#!/bin/bash

# Build the Docker image if it doesn't exist
if ! docker image inspect copilot-dotnet >/dev/null 2>&1; then
    echo "Building copilot-dotnet image..."
    docker build -t copilot-dotnet "$(dirname "$0")/dotnet"
fi

# Create GitHub Copilot config directory if it doesn't exist
mkdir -p "$HOME/.config/github-copilot"

# Run the container with mounted volumes
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.config/github-copilot":/home/copilot/.config/github-copilot \
    copilot-dotnet
