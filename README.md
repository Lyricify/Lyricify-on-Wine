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

## Maintainer
Packages in this repository are maintained by [Sheng Fan](https://github.com/fred913).  
