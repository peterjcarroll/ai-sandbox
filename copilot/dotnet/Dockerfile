FROM debian:12-slim

# Update package lists and install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    git \
    wget \
    libicu72 \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm (using NodeSource repository for latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install .NET 8 SDK
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --channel 8.0 --install-dir /usr/share/dotnet \
    && rm dotnet-install.sh \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Install GitHub Copilot CLI globally
RUN npm i -g @github/copilot

# Verify installations
RUN node --version && npm --version && dotnet --version && copilot --version

# Create a non-root user
RUN useradd -m -u 1000 -s /bin/bash copilot && \
    mkdir -p /home/copilot/.copilot && \
    chown -R copilot:copilot /home/copilot

# Set up .NET environment variables
ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH=$PATH:/usr/share/dotnet

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER copilot

# Default command - run GitHub Copilot CLI
CMD ["copilot", "--allow-all-tools"]
