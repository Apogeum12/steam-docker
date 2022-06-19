#!/bin/bash

set -e;

sudo apt update
# sudo apt-get purge -y docker-ce docker-ce-cli containerd.io \
#     docker-compose-plugin docker-ce-rootless-extras \
#     docker-scan-plugin
# TODO
#sudo rm -rf /etc/apt/keyrings/docker.gpg
#gpg --delete-keys
sudo rm -rf /etc/apt/sources.list.d/docker.list
sudo apt update
sudo rm -rf /etc/apt/keyrings/docker.gpg
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo apt -y autoremove && sudo apt -y autoclean
