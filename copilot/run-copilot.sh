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
if [ "$REBUILD" = true ] || ! docker image inspect copilot-dev >/dev/null 2>&1; then
    echo "Building copilot-dev image..."
    if [ "$REBUILD" = true ]; then
        docker build --pull --no-cache -t copilot-dev "$(dirname "$0")"
    else
        docker build -t copilot-dev "$(dirname "$0")"
    fi
fi

# Create GitHub Copilot config directory if it doesn't exist
mkdir -p "$HOME/.config/github-copilot"

# Run the container with mounted volumes
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.config/github-copilot":/home/copilot/.config/github-copilot \
    -v "$HOME/.gitconfig":/home/copilot/.gitconfig:ro \
    -v "$HOME/.ssh":/home/copilot/.ssh:ro \
    copilot-dev
