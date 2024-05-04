#!/bin/bash

function download_file_from_repo() {
    local path_in_repo=$1
    local target_path=$2
    echo "INFO: downloading $path_in_repo to $target_path"
    curl -L -o $target_path https://raw.githubusercontent.com/Lyricify/Lyricify-on-Wine/master/$path_in_repo
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

set -e

# is script being run as root?
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: This script must be run as root"
    exit 1
fi

# Check if dpkg and apt-get present
if ! command -v dpkg &>/dev/null; then
    echo "ERROR: dpkg is not present, please install it first"
    exit 1
fi

APTGET_INSTALLED=$(command -v apt-get)
if [ -z "$APTGET_INSTALLED" ]; then
    echo "INFO: apt-get is not present"
else
    echo "INFO: apt-get is present"
fi

# check if deepin-app-store-runtime and deepin-wine-helper is installed
# dpkg
if dpkg -s deepin-app-store-runtime &>/dev/null; then
    echo "INFO: deepin-app-store-runtime is already installed"
else
    echo "INFO: attempting to install deepin-app-store-runtime"
    if [ -z "$APTGET_INSTALLED" ]; then
        echo "INFO: since apt isn't present, installing deepin-app-store-runtime from Lyricify-on-Wine repo"
        download_file_from_repo "apt-missing-dependencies/deepin-app-store-runtime_1.0.2+community_amd64.deb" "/tmp/deepin-app-store-runtime_1.0.2+community_amd64.deb"

        safe_dpkg_install "/tmp/deepin-app-store-runtime_1.0.2+community_amd64.deb"
    else
        echo "INFO: installing deepin-app-store-runtime using apt-get"
        apt-get install -y deepin-app-store-runtime
        if [ $? -ne 0 ]; then
            echo "ERROR: failed to install deepin-app-store-runtime using apt-get. Falling back to dpkg"

            download_file_from_repo "apt-missing-dependencies/deepin-app-store-runtime_1.0.2+community_amd64.deb" "/tmp/deepin-app-store-runtime_1.0.2+community_amd64.deb"

            safe_dpkg_install "/tmp/deepin-app-store-runtime_1.0.2+community_amd64.deb"
        else
            echo "INFO: deepin-app-store-runtime installed successfully, using apt-get"
        fi
    fi
fi

if dpkg -s deepin-wine-helper &>/dev/null; then
    echo "INFO: deepin-wine-helper is already installed"
else
    echo "INFO: attempting to install deepin-wine-helper"
    if [ -z "$APTGET_INSTALLED" ]; then
        echo "INFO: since apt isn't present, installing deepin-wine-helper from Lyricify-on-Wine repo"
        download_file_from_repo "apt-missing-dependencies/deepin-wine-helper_5.3.14-1_amd64.deb" "/tmp/deepin-wine-helper_5.3.14-1_amd64.deb"

        safe_dpkg_install "/tmp/deepin-wine-helper_5.3.14-1_amd64.deb"
    else
        echo "INFO: installing deepin-wine-helper using apt-get"
        apt-get install -y deepin-wine-helper
        if [ $? -ne 0 ]; then
            echo "ERROR: failed to install deepin-wine-helper using apt-get. Falling back to dpkg"

            download_file_from_repo "apt-missing-dependencies/deepin-wine-helper_5.3.14-1_amd64.deb" "/tmp/deepin-wine-helper_5.3.14-1_amd64.deb"

            safe_dpkg_install "/tmp/deepin-wine-helper_5.3.14-1_amd64.deb"
        else
            echo "INFO: deepin-wine-helper installed successfully, using apt-get"
        fi
    fi
fi
