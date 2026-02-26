# Use a lightweight python image
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv (universal python package manager)
RUN pip install --no-cache-dir uv

# Set working directory
WORKDIR /app

# Copy the project files (respects .dockerignore)
COPY . .

# Install the notebooklm-mcp-cli package in system-wide mode
# This allows 'nlm' to be available globally in the container
RUN uv pip install --system .

# Default command
ENTRYPOINT ["nlm"]
CMD ["--help"]
