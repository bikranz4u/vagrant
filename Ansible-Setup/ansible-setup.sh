#!/bin/bash
apt-get update -y
apt-get install software-properties-common -y
#apt-get install ansible -y
apt-add-repository ppa:ansible/ansible -y
apt-get update -y
apt-get install ansible -y
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers


#Make sure to do  below configuration
#ssh-keygen -t rsa 4096
#ssh-copy-id vagrant@10.0.0.11
#ssh-copy-id vagrant@10.0.0.12

#=====================#
#passing ssh password via sshpass
#sshpass -p vagrant ssh-copy-id vagrant@10.0.0.11
#sshpass -p vagrant ssh-copy-id vagrant@10.0.0.12
