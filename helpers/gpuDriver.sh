#!/bin/bash

set -e;


## next intel support driver will be iris
INTEL_GPU="i915";
AMD_GPU="amdgpu";
NVIDIA_GPU="nvidia";

# PATH to file
INTEL_DIR='intel/';
AMD_DIR='amd/';
NVIDIA_DIR='nvidia/';

# TODO
#Check docker image exist

function installSteamImage(){
    docker build --no-cache . -t steam:0.5
}

function kernelGpuDriver(){
    if [ ! -z $(lspci -k |grep -EA3 'VGA|3D|DISPLAY' |grep -m 1 -oP '(?<=Kernel modules:).*' |grep $INTEL_GPU) ]
    then
        echo "[INFO] - Intel Driver!";
        cd $INTEL_DIR;
        installSteamImage;
    elif [ ! -z $(lspci -k |grep -EA3 'VGA|3D|DISPLAY' |grep -m 1 -oP '(?<=Kernel modules:).*' |grep $AMD_GPU) ]
    then
        echo "[INFO] - AMD Driver!";
        cd $AMD_DIR;
        installSteamImage
    elif [ ! -z $(lspci -k |grep -EA3 'VGA|3D|DISPLAY' |grep -m 1 -oP '(?<=Kernel modules:).*' |grep $NVIDIA_GPU) ]
    then
        echo "[INFO] - Nvidia Driver!";
        cd $NVIDIA_DIR;
        installSteamImage
    fi
}

