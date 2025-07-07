# Lyricify on Wine
这是一个存放可以在 Wine 上运行的 Lyricify 版本的仓库。

[English](README.md)

## 目录
- [Lyricify on Wine](#lyricify-on-wine)
  - [目录](#目录)
  - [发布渠道](#发布渠道)
  - [安装](#安装)
    - [通过 星火应用商店](#通过-星火应用商店)
    - [通过 Github Releases](#通过-github-releases)
      - [自动安装脚本](#自动安装脚本)
      - [手动安装](#手动安装)
  - [维护者](#维护者)

## 发布渠道
- 星火应用商店（[安装指南](#通过-星火应用商店)）
- Github Releases（[安装指南](#通过-github-releases)）
- Docker 镜像（即将推出）

*注意：经过数小时的测试，我们无法保证 APT 仓库和 Docker 镜像在多个环境中正常工作，因此暂时放弃了这种方式。*

## 安装

### 通过 星火应用商店
这种安装方式更加简单。由于这是一个中国服务，可能并非适合所有人（海外可能无法访问）。
1. 从 [官方网站](https://spark-app.store/download) 下载 Spark Store。
    - *本来这里要提醒你网站会是中文，但是既然你看了中文版的 README，我就给删了（笑）。*
2. 在应用商店中搜索 "Lyricify"。
3. 点击 "安装"。
4. 尽情享用！

### 通过 Github Releases
#### 自动安装脚本
只需在终端中执行以下命令：
```bash
curl -fsSL https://raw.githubusercontent.com/Lyricify/Lyricify-on-Wine/master/install-deb.sh > install-deb.sh && sudo bash install-deb.sh
```

如果你所在地区无法访问 `raw.githubusercontent.com`，你可以尝试使用 JSDelivr CDN 的镜像：
```bash
curl -fsSL https://cdn.jsdelivr.net/gh/Lyricify/Lyricify-on-Wine@master/install-deb.sh > install-deb.sh && sudo bash install-deb.sh
```

#### 手动安装
首先，从 [Github Releases](https://github.com/Lyricify/Lyricify-on-Wine/releases) 下载最新的发布版本（目前是 .deb 包）。
- 如果你使用的是 Deepin 或 UOS（待验证），可以直接使用 `apt` 命令安装该软件包。所有依赖项都存在于 Deepin 的 Apt 仓库中。
- 如果你使用其他基于 apt/dpkg 的 Linux 发行版，则需要手动安装依赖项。
    1. 克隆并进入此仓库：`git clone https://github.com/Lyricify/Lyricify-on-Wine.git && cd Lyricify-on-Wine`
    2. 从 "apt-missing-dependencies" 目录安装依赖项：`sudo dpkg -i apt-missing-dependencies/*.deb`
    3. 使用 `apt` 安装从 Github Releases 下载的 .deb 包中的 Lyricify 软件包。
    4. 尽情享用！
- 如果你使用非 Debian 系 Linux 发行版（即不适用 deb 软件包格式的发行版），参考下文。

## 非 Debian 系发行版的安装

该仓库提供的 `deb` 包文件对于 Debian 系发行版已经足够方便，但是对于其他发行版来说，一个 `deb` 包文件并不能提供很大的帮助。  
这里以 Arch linux 举例，对于其他发行版，使用到的相关程序请自行查找安装方法。

### 安装
- 安装要用到的程序 **spark-dwine-helper**，**dpkg** 和 **7z**
```bash
$ sudo pacman -S spark-dwine-helper dpkg p7zip
```

- 下载 [Lyricify-on-Wine](https://github.com/Lyricify/Lyricify-on-Wine) 仓库提供的 `.deb` 包，并解包，剩余的文件可以自行删除
```bash
$ curl -OL https://github.com/Lyricify/Lyricify-on-Wine/releases/download/Lyricify4/com.wxriw.lyricify4_4.2.28.240502-release-wpack240503.02_amd64.deb
$ dpkg -X com.wxriw.lyricify4_4.2.28.240502-release-wpack240503.02_amd64.deb Lyricify
$ mv Lyricify/opt/apps/com.wxriw.lyricify4/files/files.7z Lyricify/opt/apps/com.wxriw.lyricify4/files/wine_archive.7z .
$ 7z x wine_archive.7z -o./Wine-for-Lyricify
$ 7z x files.7z -o./Lyricify
$ rm *7z
```

- 将 `Lyricify` 文件夹移动到 **spark-dwine-helper** 所对应的默认 `WINEPREFIX` 路径
```bash
$ mv Lyricify/ ~/.deepinwine/
```


### 运行
至此应该已经能正常地运行 Lyricify 4，这里假设最初的工作目录是 `~/.Lyricify`
```bash
$ APPRUN_CMD=~/.Lyricify/Wine-for-Lyricify/bin/wine64 /opt/deepinwine/tools/spark_run_v4.sh "Lyricify" "4.2.28.240502-release-wpack240503.02" "C:/Program Files/Lyricify 4/Lyricify for Spotify.exe"
```


### 编写 `.desktop` 文件以将应用程序集成到应用程序菜单中
编辑 `~/.local/share/applications/com.wxriw.lyricify4.desktop` 文件
```
#!/usr/bin/env xdg-open
[Desktop Entry]
Encoding=UTF-8
Type=Application
Categories=Audio;
# 解包时该文件的相对路径应该是
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

编辑 `~/.Lyricify/run.sh` 文件
```bash
#!/bin/bash

export APPRUN_CMD=~/.Lyricify/Wine-for-Lyricify/bin/wine64 
/opt/deepinwine/tools/spark_run_v4.sh "Lyricify" "4.2.28.240502-release-wpack240503.02" "C:/Program Files/Lyricify 4/Lyricify for Spotify.exe"
```

## 一些可能的问题
- 在进行 Spotify 授权的时候浏览器无法正常弹出，需要点击左下角的 `登录时遇到问题？` 按钮手动打开浏览器授权。
- 应用界面出现奇怪的显示问题，打开 `设置-Apple Music 歌词-背景-动态` 可以缓解该问题。

## 维护者
该仓库中的软件包由 [Sheng Fan](https://github.com/fred913) 维护。
关于非 Debian 系发行版的安装方法由 [Chumeng](https://github.com/lihaoze123) 维护。
