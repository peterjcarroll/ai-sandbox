FROM debian:12-slim

# Update package lists
RUN apt-get update

# Install dependencies (one per line for better Docker caching)
RUN apt-get install -y build-essential
RUN apt-get install -y ca-certificates
RUN apt-get install -y curl
RUN apt-get install -y git
RUN apt-get install -y gnupg
RUN apt-get install -y python3
RUN apt-get install -y python3-dev
RUN apt-get install -y python3-pip
RUN apt-get install -y python3-venv
RUN apt-get install -y texlive-luatex
RUN apt-get install -y texlive-latex-extra
RUN apt-get install -y texlive-fonts-recommended
RUN apt-get install -y texlive-music
RUN apt-get install -y imagemagick
RUN apt-get install -y librsvg2-bin
RUN apt-get install -y pdf2svg
RUN apt-get install -y cairosvg

# Clean up apt cache
RUN rm -rf /var/lib/apt/lists/*

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
