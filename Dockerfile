# Use Ubuntu as the base image
FROM ubuntu:latest AS runner

# Install SSH Server
RUN apt-get update && \
    apt-get install -y \
    openssh-server \
    sudo \
    vim \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create a user (e.g., 'dev') and set the password
RUN useradd -rm -d /home/dev -s /bin/bash -g root -G sudo -u 1001 dev

# SSH login fix. Otherwise, the user is kicked off after login
RUN mkdir /var/run/sshd

# Change SSH settings to allow port forwarding
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#AllowTcpForwarding no/AllowTcpForwarding yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitTunnel no/PermitTunnel yes/' /etc/ssh/sshd_config

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the SSH port
EXPOSE 22

# Run the SSH server
ENTRYPOINT [ "/entrypoint.sh" ]
