FROM debian:12-slim

# Update package lists and install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    git \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Create symlinks for python and pip
RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

# Install Node.js and npm (using NodeSource repository for latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub Copilot CLI globally
RUN npm i -g @github/copilot

# Verify installations
RUN node --version && npm --version && python --version && pip --version && copilot --version

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
