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
if [ "$REBUILD" = true ] || ! docker image inspect codex-typescript >/dev/null 2>&1; then
    echo "Building codex-typescript image..."
    if [ "$REBUILD" = true ]; then
        docker build --pull --no-cache -t codex-typescript "$(dirname "$0")/typescript"
    else
        docker build -t codex-typescript "$(dirname "$0")/typescript"
    fi
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
