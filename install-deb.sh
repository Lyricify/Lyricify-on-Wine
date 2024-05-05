#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Please run as root"
    exit 1
fi

# Check requirements
for cmd in dpkg; do
    if ! command -v $cmd &>/dev/null; then
        echo "ERROR: $cmd is not present, please install it first"
        exit 1
    fi
done

APT_GET_INSTALLED=true
if ! command -v apt-get &>/dev/null; then
    echo "WARN: apt-get is not present, falling back to dpkg"
    APT_GET_INSTALLED=false
fi

# check other dependencies: curl, jq
for cmd in curl jq; do
    if ! command -v $cmd &>/dev/null; then
        if [ "$APT_GET_INSTALLED" = "true" ]; then
            echo "INFO: $cmd is not present, attempting to install it using apt-get"
            apt-get install -y $cmd
            if [ $? -ne 0 ]; then
                echo "ERROR: failed to install $cmd using apt-get"
                exit 1
            else
                echo "INFO: $cmd installed successfully using apt-get"
            fi
        else
            echo "ERROR: $cmd is not present, please install it first"
            exit 1
        fi
    fi
done

# check optional dependencies
ARIA2C_INSTALLED=true
if ! command -v aria2c &>/dev/null; then
    if [ "$APT_GET_INSTALLED" = "true" ]; then
        echo "INFO: aria2c is not present, attempting to install it using apt-get"
        apt-get install -y aria2c
        if [ $? -ne 0 ]; then
            echo "WARN: aria2c is not present, falling back to curl"
            ARIA2C_INSTALLED=false
        else
            echo "INFO: aria2c installed successfully using apt-get"
        fi
    else
        echo "WARN: aria2c is not present, falling back to curl"
        ARIA2C_INSTALLED=false
    fi
else
    echo "INFO: aria2c installed"
fi

function parse_json() {
    local json_content=$1
    local key=$2
    echo $(echo $json_content | jq -r ".$key")
}

function download_file_from_url() {
    local url=$1
    local target_path=$2

    if [ -f $target_path ]; then
        echo "INFO: $target_path already exists, removing it"
        rm $target_path
    fi

    echo "INFO: downloading $url to $target_path"
    if [ "$ARIA2C_INSTALLED" = "true" ]; then
        echo "INFO: aria2c is installed, allowing parallel downloads"
        # aria2c -o $target_path $url
        aria2c -d $(dirname $target_path) -o $(basename $target_path) $url
    else
        echo "INFO: aria2c is not installed, falling back to curl"
        curl -L -o $target_path $url
    fi
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to download $url"
        exit 1
    fi
}

# check if raw.githubusercontent.com is accessible
RAW_GITHUB_AVAILABLE=true
if ! curl -s https://raw.githubusercontent.com/Lyricify/Lyricify-on-Wine/master/install-deb.sh | grep -q "raw.githubusercontent.com"; then
    echo "WARN: raw.githubusercontent.com is not accessible. Using JSDelivr instead"
    RAW_GITHUB_AVAILABLE=false
fi

function download_file_from_repo() {
    local path_in_repo=$1
    local target_path=$2

    if [ -f $target_path ]; then
        echo "INFO: $target_path already exists, removing it"
        rm $target_path
    fi

    echo "INFO: downloading $path_in_repo to $target_path"
    if [ "$RAW_GITHUB_AVAILABLE" = "true" ]; then
        url=https://raw.githubusercontent.com/Lyricify/Lyricify-on-Wine/master/$path_in_repo
    else
        url=https://cdn.jsdelivr.net/gh/Lyricify/Lyricify-on-Wine@master/$path_in_repo
    fi
    download_file_from_repo $url "/tmp/${path_in_repo}"
    if [ $? -ne 0 ]; then
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

check_and_install_package "deepin-app-store-runtime" "deepin-app-store-runtime_1.0.2+community_amd64.deb"
check_and_install_package "deepin-wine-helper" "deepin-wine-helper_5.3.14-1_amd64.deb"

echo "INFO: All dependencies installed successfully"

# fetch the latest version from Github Releases
latest_release=$(curl -H "Accept: application/vnd.github+json" -s "https://api.github.com/repos/Lyricify/Lyricify-on-Wine/releases/latest")

# extract the download URL from the latest release
release_id=$(parse_json "$latest_release" "id")
version_name=$(parse_json "$latest_release" "name")
upload_datetime=$(parse_json "$latest_release" "published_at")
download_url=$(parse_json "$latest_release" "assets[0].browser_download_url")

# echo "INFO: Extracted download URL: $download_url"
echo "INFO: Version information (latest):"
echo "  Release ID: $release_id"
echo "  Version Name: $version_name"
echo "  Upload Date: $upload_datetime"
echo "  Download URL: $download_url"
echo ""

# prompt the user to confirm the download
read -p "Install $version_name? [Y/n] " answer
if [[ "$answer" =~ ^[Nn]$ ]]; then
    echo "INFO: abandoning installation of $version_name"
else
    # download the package
    echo "INFO: Downloading $version_name from $download_url"
    # if ! curl -L -o /tmp/lyricify.deb $download_url; then
    #     echo "ERROR: Failed to download $version_name"
    #     exit 1
    # fi
    download_file_from_url $download_url /tmp/lyricify.deb

    # install the package
    echo "INFO: Installing $version_name"
    safe_dpkg_install /tmp/lyricify.deb

    # clean up
    rm /tmp/lyricify.deb

    echo "INFO: $version_name installed successfully"

    read -p "Install shortcut for Lyricify on Wine in /usr/bin? [Y/n] " answer
    if [[ "$answer" =~ ^[Nn]$ ]]; then
        echo "INFO: Skipping shortcut installation"
        echo "INFO: To launch Lyricify, run /opt/apps/com.wxriw.lyricify4/files/run.sh or start from applications menu"
    else
        # create the shortcut
        # target: /opt/apps/com.wxriw.lyricify4/files/run.sh
        cat >/usr/bin/lyricify-launcher <<EOF
#!/bin/bash
/opt/apps/com.wxriw.lyricify4/files/run.sh
EOF
        chmod +x /usr/bin/lyricify-launcher
        echo "INFO: Shortcut installed successfully"
        echo "INFO: To launch Lyricify, run lyricify-launcher"
    fi

fi
echo "INFO: Done"
