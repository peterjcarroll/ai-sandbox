FROM debian:12-slim

# Update package lists and install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm (using NodeSource repository for latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Codex CLI globally
RUN npm install -g @openai/codex@latest

# Verify installations
RUN node --version && npm --version && codex --version

# Create a non-root user
RUN useradd -m -u 1000 -s /bin/bash codex && \
    mkdir -p /home/codex/.codex && \
    chown -R codex:codex /home/codex

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER codex

# Default command - run Codex
CMD ["codex", "--dangerously-bypass-approvals-and-sandbox"]
