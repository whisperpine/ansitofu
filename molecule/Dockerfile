# The default ubuntu image dosn't have python3 installed.
# Ansible requires the target host to have python3 installed.
# Therefore, we build a dedicated container image for test purpose.

FROM ubuntu:24.04

# Prevent interactive prompts during build.
ENV DEBIAN_FRONTEND=noninteractive

# Update package index and install Python.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo systemd systemd-sysv dbus \
    python3 python3-cryptography && \
    rm -rf /var/lib/apt/lists/*

# Give the ubuntu user sudo privileges.
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the ubuntu user by default.
USER ubuntu

# Set working directory in the user's home.
WORKDIR /home/ubuntu
