#!/bin/bash

set -e;

function installDockerEngine(){
    echo "[INFO] - Install dependencies.";
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    echo "[INFO] - Done!"  
}
function setUpRepository(){
    echo "[INFO] - Install dependencies.";
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sleep 1;
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo "[INFO] - Done!"
}
function addGPGKey(){
    echo "[INFO] - addGPGKey.";
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "[INFO] - Done!"
}
function installDependencies(){
    echo "[INFO] - Install dependencies.";
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg lsb-release
    echo "[INFO] - Done!"

}
# Main #
function dockerInstallation(){
    installDependencies;
    sleep 1;
    addGPGKey;
    sleep 1;
    setUpRepository;
    sleep 1;
    installDockerEngine;
}


# Main #
function checkGroupExist(){
    if [ ! -z $(groups |grep -m 1 -oP 'docker') ]
    then
        echo "true"
    else
        echo "false";
    fi
}
function dockerPostInstall(){
    echo "[INFO] - Add user to group.";
    local isGroup=$(checkGroupExist);
    if [ $isGroup == "false" ]
    then
        sudo groupadd -f docker
        sudo usermod -aG docker $USER
    else
        echo "[INFO] - Docker group exist."
    fi
    sudo usermod -aG docker $USER
    if [ $isGroup == "false" ]
    then
        newgrp docker
    fi
    sleep 2;
    sudo systemctl stop docker.service
    sleep 1;
    sudo systemctl stop containerd.service
    sleep 1;
    sudo systemctl disable docker.service
    sleep 1;
    sudo systemctl disable containerd.service
    sleep 1;
    systemctl daemon-reload 
    echo "[INFO] - Done!"
}

# TODO
# Before running app must be start docker service
#  sudo systemctl start docker.service
#  sudo systemctl start containerd.service
# After clouse app must be stop docker service
#  sudo systemctl stop docker.service
#  sudo systemctl stop containerd.service

# Non running docker service when boot system
#  sudo systemctl disable docker.service
#  sudo systemctl disable containerd.service
# Run docker service on boot system
#  sudo systemctl enable docker.service
#  sudo systemctl enable containerd.service