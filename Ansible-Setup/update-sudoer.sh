#!/bin/bash
apt-get update -y
mkdir -p /home/vagrant/ansible-setup/
chown -R vagrant:vagrant /home/vagrant/ansible-setup/
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
