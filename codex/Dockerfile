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
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

# Install Node.js and npm (using NodeSource repository for latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install OpenAI Python SDK globally
RUN pip install --no-cache-dir openai

# Install OpenAI Node.js SDK globally
RUN npm install -g openai

# Verify installations
RUN node --version && npm --version && python --version && pip --version

# Create a non-root user
RUN useradd -m -u 1000 -s /bin/bash codex && \
    mkdir -p /home/codex/.config && \
    chown -R codex:codex /home/codex

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER codex

# Default command - start bash shell
CMD ["/bin/bash"]
