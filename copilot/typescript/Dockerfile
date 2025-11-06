FROM debian:12-slim

# Update package lists and install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm (using NodeSource repository for latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install TypeScript, development tools, and GitHub Copilot CLI globally
RUN npm install -g \
    typescript \
    ts-node \
    @types/node \
    @githubnext/github-copilot-cli

# Verify installations
RUN node --version && npm --version && tsc --version && github-copilot-cli --version

# Create a non-root user
RUN useradd -m -u 1000 -s /bin/bash copilot && \
    mkdir -p /home/copilot/.config && \
    chown -R copilot:copilot /home/copilot

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER copilot

# Default command - run GitHub Copilot CLI
CMD ["github-copilot-cli"]
