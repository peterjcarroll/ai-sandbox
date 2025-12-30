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
RUN npm i -g \
    typescript \
    ts-node \
    @types/node \
    @github/copilot

# Verify installations
RUN node --version && npm --version && tsc --version && copilot --version

# Create a non-root user
RUN useradd -m -u 1000 -s /bin/bash copilot && \
    mkdir -p /home/copilot/.copilot && \
    chown -R copilot:copilot /home/copilot

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER copilot

# Default command - run GitHub Copilot CLI
CMD ["copilot", "--allow-all-tools"]
