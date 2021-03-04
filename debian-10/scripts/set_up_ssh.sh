#!/bin/bash -eux

username='ansible'

# Create .ssh directory for user
mkdir /home/$username/.ssh
chmod 0700 /home/$username/.ssh

# Add public key
echo "ssh-rsa INSERT YOUR KEY HERE" > /home/$username/.ssh/authorized_keys
chmod 0600 /home/$username/.ssh/authorized_keys

# Set ownership
chown -R $username:$username /home/$username/.ssh