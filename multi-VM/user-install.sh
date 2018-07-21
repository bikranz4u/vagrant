#!/bin/bash
# This is a test user
/usr/sbin/useradd  ansible
mkdir  /home/ansible/.ssh
touch  /home/ansible/.ssh/authorized_keys
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCm53n4lIgMcNw9PtxLkviAv0EKgvuazIoMMhEu7ZBRXUmqWpx+nYa/df5d9nS0JiJcPRWeQuR7LdjJGvT4xzLcTn/CY0VX+tZ6bYYdTEjHcmbSs3G43230G+ntuDfhQbKohGSRc5z4QeABWQPiyCW+gfvKb1lKpKeyXSVlMkRYnsNbMwx68BhCchq+3pQqiAfwZzwHaDEveaNnRXvEmr4xD5MBwv5c0O7JjPV89FnUIcpB/UbpkjrotUOzBDFW0qtZLA6MPv1z69Q4j11tRphhZ4DroPNiirmIq2+G5Sz5gxeuS1bCGOXnycoEud8VRr7tPiqBUgecQ663WsmgQ0Fl' >> /home/ansible/.ssh/authorized_keys
chmod 400 /home/ansible/.ssh/authorized_keys
chmod 700 /home/ansible/.ssh
chown -R ansible:ansible /home/ansible/.ssh/
