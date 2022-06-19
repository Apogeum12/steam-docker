#!/bin/bash

set -e;
source './helpers/installDocker.sh';

D_LIBRARY=${1};
GPU_TYPE=${2};

# Arguments check
if [ ! $# -eq 2 ]
then
    echo "[INFO] - You must pass 2 arguments!";
    echo "Example: ";
    echo "  bash ./build (mesa || nvidia) (intel || amd || nvidia)";
    exit 3;
fi
function isDockerInstall(){
    if [ ! -z $(apt list --installed |grep -m 1 -oP 'docker|containerd') ]
    then
        echo "true";
    else
        echo "false";
    fi
}
function dockerInstall(){
    local isDOCKER=$(isDockerInstall);
    if [ $isDOCKER == 'false' ]
    then
        dockerInstallation;
        local installComplety=$(isDockerInstall);
        if [ $installComplety == 'true' ]
        then
            echo "[INFO] - Docker installed properly.";
        else
            echo "[ERROR] - Docker isn't installed."
            exit 3;
        fi
    else
        echo "[INFO] - Docker is installed!";
    fi
}

# Type Library and gpu check (Nvidia non support)
if [ $D_LIBRARY == 'nvidia' ] || [ $GPU_TYPE == 'nvidia' ]
then
    echo "[ERROR] - Nvidia currently isn't support!";
    exit 3;
elif [ $D_LIBRARY != 'mesa' ]
then
    echo "[ERROR] - Graphic Library must be MESA!";
    exit 3;
fi

dockerInstall;
dockerPostInstall;
# TODO install gpu version docker image
# TODO install steam in docker

# get GPU kernel driver 
# lspci -k |grep -EA3 'VGA|3D|DISPLAY' |grep 'Kernel modules'