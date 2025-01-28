#!/bin/bash

# Set SSH password if the environment variable is defined
if [ -n "${DEV_TUNNEL_SSH_PASSWORD}" ]; then
    echo "Setting SSH password for dev user"
    echo "dev:${DEV_TUNNEL_SSH_PASSWORD}" | chpasswd
fi

# Create the directory for privilege separation if it doesn't exist
mkdir -p /run/sshd

# Start SSH service
echo "Starting SSH service"
/usr/sbin/sshd -D
