#!/bin/bash

echo "Setting SSH password"
echo "dev:${DEV_TUNNEL_SSH_PASSWORD}" | chpasswd

# Start SSH service
echo "Starting SSH service"
/usr/sbin/sshd -D