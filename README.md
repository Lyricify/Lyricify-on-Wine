# Lyricify on Wine
This is a repository for Lyricify releases that can run on Wine.  

[简体中文](README.zh-CN.md)

## Table of Contents
- [Lyricify on Wine](#lyricify-on-wine)
  - [Table of Contents](#table-of-contents)
  - [Releasing Methods](#releasing-methods)
  - [Installation](#installation)
    - [via Github Releases](#via-github-releases)
      - [Auto-install Script](#auto-install-script)
      - [Manual Install](#manual-install)
    - [via Spark Store](#via-spark-store)
  - [Maintainer](#maintainer)

## Releasing Methods
- Github Releases ([Installation Guide](#via-github-releases))
- Spark Store ([Installation Guide](#via-github-releases))

*NOTE: after hours of testing, the APT repo and the Docker image cannot be guaranteed to work properly, so the way is abandoned for now.*

## Installation

### via Github Releases
#### Auto-install Script
Just execute the following command in your terminal:
```bash
curl -fsSL https://raw.githubusercontent.com/Lyricify/Lyricify-on-Wine/master/install-deb.sh > install-deb.sh && sudo bash install-deb.sh
```

If `raw.githubusercontent.com` is blocked in your region, you can try the other one below, which uses JSDelivr CDN:
```bash
curl -fsSL https://cdn.jsdelivr.net/gh/Lyricify/Lyricify-on-Wine@master/install-deb.sh > install-deb.sh && sudo bash install-deb.sh
```

#### Manual Install
First of all, download the latest release (currently .deb package) from [Github Releases](https://github.com/Lyricify/Lyricify-on-Wine/releases).
-  If you're using Deepin or UOS(unverified), install the package using `apt` command directly. All dependecies exist in Deepin's Apt repository.
-  If you're using other apt/dpkg-based Linux distributions, you'd have to install dependencies manually.
    1. Clone and enter this repository: `git clone https://github.com/Lyricify/Lyricify-on-Wine.git && cd Lyricify-on-Wine`
    2. Install the dependencies from "apt-missing-dependencies" directory: `sudo dpkg -i apt-missing-dependencies/*.deb`
    3. Install the Lyricify package from the .deb package you downloaded from Github Releases using `apt`.
    4. Enjoy!

### via Spark Store
This way installation is much easier. Since it's a Chinese service it might not be suitable and accessible for everyone.
1. Download Spark Store from [its official website](https://spark-app.store/download). (*might be chinese!*)
2. Search for "Lyricify" from the app store.
3. Click on "Install".
4. Enjoy!

## Installation for Non-Debian-based Distributions

If you are using a non-Debian-based Linux distribution (i.e., distributions that don't use the deb package format), refer to the following.
The `deb` package files provided by this repository are convenient enough for Debian-based distributions, but for other distributions, a `deb` package file doesn't offer much help.  
Here, we'll use Arch Linux as an example. For other distributions, please find and install the relevant programs on your own.

### Installation
- Install the required programs **spark-dwine-helper**, **dpkg**, and **7z**
```bash
$ sudo pacman -S spark-dwine-helper dpkg p7zip
```

- Download the `.deb` package provided by the [Lyricify-on-Wine](https://github.com/Lyricify/Lyricify-on-Wine) repository, unpack it, and you can delete the remaining files as needed
```bash
$ curl -OL https://github.com/Lyricify/Lyricify-on-Wine/releases/download/Lyricify4/com.wxriw.lyricify4_4.2.28.240502-release-wpack240503.02_amd64.deb
$ dpkg -X com.wxriw.lyricify4_4.2.28.240502-release-wpack240503.02_amd64.deb Lyricify
$ mv Lyricify/opt/apps/com.wxriw.lyricify4/files/files.7z Lyricify/opt/apps/com.wxriw.lyricify4/files/wine_archive.7z .
$ 7z x wine_archive.7z -o./Wine-for-Lyricify
$ 7z x files.7z -o./Lyricify
$ rm *7z
```

- Move the `Lyricify` folder to the default `WINEPREFIX` path corresponding to **spark-dwine-helper**
```bash
$ mv Lyricify/ ~/.deepinwine/
```

### Running
At this point, you should be able to run Lyricify 4 normally. Here, we assume the initial working directory is `~/.Lyricify`
```bash
$ APPRUN_CMD=~/,Lyricify/Wine-for-Lyricify/bin/wine64 /opt/deepinwine/tools/spark_run_v4.sh "Lyricify" "4.2.28.240502-release-wpack240503.02" "C:/Program Files/Lyricify 4/Lyricify for Spotify.exe"
```

### Writing a `.desktop` file to integrate the application into the application menu
Edit the `~/.local/share/applications/com.wxriw.lyricify4.desktop` file
```
#!/usr/bin/env xdg-open
[Desktop Entry]
Encoding=UTF-8
Type=Application
Categories=Audio;
# The relative path of this file when unpacking should be
# ./opt/apps/com.wxriw.lyricify4/entries/icons/hicolor/scalable/apps/com.wxriw.lyricify4.png
Icon=~/.Lyricify/com.wxriw.lyricify4.png
Exec="~/.Lyricify/run.sh" --uri 
Name=Lyricify
Comment=Lyricify 4 in a Wine container
MimeType=
GenericName=com.wxriw.lyricify4
Terminal=false
StartupNotify=false
```

Edit the `~/.Lyricify/run.sh` file
```bash
#!/bin/bash

export APPRUN_CMD=~/.Lyricify/Wine-for-Lyricify/bin/wine64 
/opt/deepinwine/tools/spark_run_v4.sh "Lyricify" "4.2.28.240502-release-wpack240503.02" "C:/Program Files/Lyricify 4/Lyricify for Spotify.exe"
```

## Some Possible Issues
- When authorizing Spotify, the browser may not pop up normally. You need to click the `Problems logging in?` button in the lower left corner to manually open the browser for authorization.
- If there are strange display issues with the application interface, opening `Settings-Apple Music Lyrics-Background-Dynamic` can alleviate this problem.

## Maintainer
Packages in this repository are maintained by [Sheng Fan](https://github.com/fred913).  
The installation methods for non-Debian based distributions are maintained by [Chumeng](https://github.com/lihaoze123).
