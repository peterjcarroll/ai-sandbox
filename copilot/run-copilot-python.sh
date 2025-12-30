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
if [ "$REBUILD" = true ] || ! docker image inspect copilot-python >/dev/null 2>&1; then
    echo "Building copilot-python image..."
    if [ "$REBUILD" = true ]; then
        docker build --pull --no-cache -t copilot-python "$(dirname "$0")/python"
    else
        docker build -t copilot-python "$(dirname "$0")/python"
    fi
fi

# Create GitHub Copilot config directory if it doesn't exist
mkdir -p "$HOME/.copilot"

# Run the container with mounted volumes
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -v "$HOME/.copilot":/home/copilot/.copilot \
    copilot-python
