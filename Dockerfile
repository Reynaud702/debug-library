# Dockerfile for x86-64 assembly development
FROM --platform=linux/amd64 ubuntu:22.04

# Install development tools
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    binutils \
    gdb \
    make \
    libc6-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy project files
COPY . .

# Default command
CMD ["/bin/bash"]
