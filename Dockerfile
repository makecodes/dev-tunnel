# Use Ubuntu as the base image
FROM ubuntu:latest AS runner

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install SSH Server and other utilities
RUN apt-get update && \
    apt-get install -y \
    curl \
    net-tools \
    openssh-server \
    sudo \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create a user (e.g., 'dev') and set the password
RUN useradd -rm -d /home/dev -s /bin/bash -g root -G sudo -u 1001 dev && \
    mkdir -p /home/dev/.ssh && \
    chmod 700 /home/dev/.ssh

# SSH login fix. Otherwise, the user is kicked off after login
RUN mkdir /var/run/sshd

# Update SSH settings to restrict authentication to public key only
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#AllowTcpForwarding no/AllowTcpForwarding yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitTunnel no/PermitTunnel yes/' /etc/ssh/sshd_config

# Add the custom entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the SSH port
EXPOSE 22

# Run the SSH server
ENTRYPOINT [ "/entrypoint.sh" ]
