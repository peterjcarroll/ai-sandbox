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
    texlive-luatex \
    texlive-music \
    texlive-latex-extra \
    texlive-fonts-recommended \
    pdf2svg \
    imagemagick \
    && rm -rf /var/lib/apt/lists/*

# Create symlinks for python and pip
RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

# Install Node.js and npm (using NodeSource repository for latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI globally
RUN npm install -g @anthropic-ai/claude-code

# Install Python packages for GABC/SVG manipulation
RUN pip install --break-system-packages --no-cache-dir svgpathtools lxml pillow

# Verify installations
RUN node --version && npm --version && python --version && pip --version && claude --version

# Create a non-root user
RUN useradd -m -u 1000 -s /bin/bash claude && \
    mkdir -p /home/claude/.claude /home/claude/.config/claude-code && \
    chown -R claude:claude /home/claude

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER claude

# Default command - run Claude Code
CMD ["claude", "--dangerously-skip-permissions"]
