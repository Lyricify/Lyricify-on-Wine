#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Please run as root"
    exit 1
fi

function download_file_from_repo() {
    local path_in_repo=$1
    local target_path=$2

    if [ -f $target_path ]; then
        echo "INFO: $target_path already exists, removing it"
        rm $target_path
    fi

    echo "INFO: downloading $path_in_repo to $target_path"
    if ! curl -L -o $target_path https://raw.githubusercontent.com/Lyricify/Lyricify-on-Wine/master/$path_in_repo; then
        echo "ERROR: Failed to download $path_in_repo"
        exit 1
    fi
}

function safe_dpkg_install() {
    local package_filepath=$1
    echo "INFO: installing $package_filepath using dpkg"
    dpkg -i $package_filepath
    if [ $? -ne 0 ]; then
        echo "ERROR: failed to install $package_filepath using dpkg"
        exit 1
    else
        echo "INFO: $package_filepath installed successfully using dpkg"
    fi
}

function check_and_install_package() {
    local package_name=$1
    local package_name_in_repo=$2

    if dpkg-query -W -f='${Status}' $package_name 2>/dev/null | grep -q "install ok installed"; then
        echo "INFO: $package_name is already installed"
    else
        echo "INFO: attempting to install $package_name"
        apt-get install -y $package_name
        if [ $? -ne 0 ]; then
            echo "ERROR: failed to install $package_name using apt-get. Falling back to dpkg"
            download_file_from_repo "apt-missing-dependencies/${package_name_in_repo}" "/tmp/${package_name_in_repo}"
            safe_dpkg_install "/tmp/${package_name_in_repo}"
            rm "/tmp/${package_name_in_repo}"
        else
            echo "INFO: $package_name installed successfully, using apt-get"
        fi
    fi
}

# Check if dpkg, apt-get and curl are present
for cmd in dpkg apt-get curl; do
    if ! command -v $cmd &>/dev/null; then
        echo "ERROR: $cmd is not present, please install it first"
        exit 1
    fi
done

check_and_install_package "deepin-app-store-runtime" "deepin-app-store-runtime_1.0.2+community_amd64.deb"
check_and_install_package "deepin-wine-helper" "deepin-wine-helper_5.3.14-1_amd64.deb"
