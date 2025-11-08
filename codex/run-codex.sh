#!/bin/bash

# Parse flags
REBUILD=false
ARGS=()
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --rebuild) REBUILD=true; shift ;;
        *) ARGS+=("$1"); shift ;;
    esac
done

# Build the Docker image if it doesn't exist or if rebuild is forced
if [ "$REBUILD" = true ] || ! docker image inspect codex-dev >/dev/null 2>&1; then
    echo "Building codex-dev image..."
    if [ "$REBUILD" = true ]; then
        docker build --pull --no-cache -t codex-dev "$(dirname "$0")"
    else
        docker build -t codex-dev "$(dirname "$0")"
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
    codex-dev "${ARGS[@]}"
