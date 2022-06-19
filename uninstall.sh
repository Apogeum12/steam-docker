#!/bin/bash

set -e;

sudo systemctl stop docker.service
sudo systemctl stop containerd.service
sleep 2;

sudo apt update
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io \
    docker-compose-plugin docker-ce-rootless-extras \
    docker-scan-plugin
sleep 1;

sudo rm -rf /etc/apt/sources.list.d/docker.list
sudo apt update
sudo rm -rf /etc/apt/keyrings/docker.gpg
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo apt -y autoremove && sudo apt -y autoclean
