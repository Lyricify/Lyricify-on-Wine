# Lyricify on Wine
这是一个存放可以在 Wine 上运行的 Lyricify 版本的仓库。

[English](README.md)

## 目录
- [Lyricify on Wine](#lyricify-on-wine)
  - [目录](#目录)
  - [发布渠道](#发布渠道)
  - [安装](#安装)
    - [通过 Spark Store](#通过-spark-store)
    - [通过 Github Releases](#通过-github-releases)
  - [维护者](#维护者)

## 发布渠道
- Spark Store（[安装指南](#通过-github-releases)）
- Github Releases（[安装指南](#通过-github-releases)）
- APT 仓库（即将推出）
- Docker 镜像（即将推出）

## 安装

### 通过 Spark Store
这种安装方式更加简单。由于这是一个中国服务，可能并非适合所有人（海外可能无法访问）。
1. 从 [官方网站](https://spark-app.store/download) 下载 Spark Store。
- *本来这里要提醒你网站会是中文，但是既然你看了中文版的 README，我就给删了（笑）。*
2. 在应用商店中搜索 "Lyricify"。
3. 点击 "安装"。
4. 尽情享用！

### 通过 Github Releases
首先，从 [Github Releases](https://github.com/Lyricify/Lyricify-on-Wine/releases) 下载最新的发布版本（目前是 .deb 包）。
- 如果你使用的是 Deepin 或 UOS（待验证），可以直接使用 `apt` 命令安装该软件包。所有依赖项都存在于 Deepin 的 Apt 仓库中。
- 如果你使用其他基于 apt/dpkg 的 Linux 发行版，则需要手动安装依赖项。
    1. 克隆并进入此仓库：`git clone https://github.com/Lyricify/Lyricify-on-Wine.git && cd Lyricify-on-Wine`
    2. 从 "apt-missing-dependencies" 目录安装依赖项：`sudo dpkg -i apt-missing-dependencies/*.deb`
    3. 使用 `apt` 安装从 Github Releases 下载的 .deb 包中的 Lyricify 软件包。
    4. 尽情享用！

## 维护者
该仓库中的软件包由 [Sheng Fan](https://github.com/fred913) 维护。