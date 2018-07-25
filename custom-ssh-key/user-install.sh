#!/bin/bash
# This is a test user
/usr/sbin/useradd  ansible
mkdir -p /home/ansible/.ssh
touch  /home/ansible/.ssh/authorized_keys
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLIyA+OaDo/fkdjm3aVFZWHGw//qF42fugagfItoGVsQS8BRkBTsXVeNIr8GltZPQ+nkQUQ4GUZj5fxMh5ryfGzNU4zHpdTxgEZewjtCXyU38x+LP5bzu6VyfzBFP1gCejwx5ecTY6IDdjsJ1OCr6MKU7C1vK9tl+HSR7PaixYfXfbLnVel28P+zxVnfpUzZGNqC3U7j/wDw48WeXkqtguLgq39aKMw85gRpclchVyU1JpuChG8P8IRbBbax+sqXGKU9AkgR9CWeZLaRdHiHdOHihREIQmqsabjTEcklizK9hIfUlc8zawmsKB0ntnE9ta29i7AKGw0M35mNs9mIOZ bikrdas@BIKRDAS-M-91H4' >> /home/ansible/.ssh/authorized_keys
chmod 400 /home/ansible/.ssh/authorized_keys
chmod 700 /home/ansible/.ssh
chown -R ansible:ansible /home/ansible/.ssh/
echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
