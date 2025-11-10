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

# Create and activate virtual environment for Python tools
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
RUN python3 -m venv "${VIRTUAL_ENV}" \
    && python -m pip install --no-cache-dir --upgrade pip \
    && python -m pip install --no-cache-dir openai

# Create codex script
RUN cat <<'EOF' >/usr/local/bin/codex
#!/opt/venv/bin/python
import os
import sys
import textwrap
from openai import OpenAI

MODEL_ENV_VAR = "OPENAI_MODEL"
DEFAULT_MODEL = "gpt-4o-mini"

def get_model() -> str:
    return os.environ.get(MODEL_ENV_VAR, DEFAULT_MODEL)

def ensure_api_key() -> None:
    if not os.environ.get("OPENAI_API_KEY"):
        msg = (
            "Missing OPENAI_API_KEY environment variable. "
            "Please export your OpenAI API key before running Codex."
        )
        print(msg, file=sys.stderr)
        sys.exit(1)

def make_request(prompt: str) -> None:
    client = OpenAI()
    response = client.responses.create(
        model=get_model(),
        input=prompt,
        max_output_tokens=800
    )
    print(response.output_text.strip())

def run_once(prompt: str) -> None:
    ensure_api_key()
    make_request(prompt)

def run_interactive() -> None:
    ensure_api_key()
    intro = textwrap.dedent(
        f"""
        OpenAI Codex interactive shell. Type your prompt and press Enter twice to submit.
        Currently targeting model: {get_model()}
        Set {MODEL_ENV_VAR} to override the model (default: {DEFAULT_MODEL}).
        Press Ctrl+D to exit.
        """
    ).strip()
    print(intro)
    buffer = []
    client = OpenAI()
    while True:
        try:
            line = input("codex> ")
        except EOFError:
            print()
            break
        if not line.strip():
            if not buffer:
                continue
            prompt = "\n".join(buffer)
            buffer.clear()
            try:
                response = client.responses.create(
                    model=get_model(),
                    input=prompt,
                    max_output_tokens=800
                )
                print(response.output_text.strip())
            except Exception as exc:
                print(f"[Codex error] {exc}", file=sys.stderr)
        else:
            buffer.append(line)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        run_once(" ".join(sys.argv[1:]))
    else:
        run_interactive()
EOF

# Make codex script executable
RUN chmod +x /usr/local/bin/codex

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

# Default command - run Codex helper
CMD ["codex"]
