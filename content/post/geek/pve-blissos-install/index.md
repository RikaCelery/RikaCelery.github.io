---
title: "Pve 安装 BlissOS Zenith（安卓13）"
description: 
date: 2025-03-20T00:34:15+08:00
image: 
math: 
license: 
fullpage: 
toc: 
hidden: false
comments: 
categories: 
  - geek
tags: 
draft: false
---
## 起因

~~老婆在玩如鸳，刷本，mumu模拟器老卡死~~

~~我就想着NAS都装好了，不搞个安卓虚拟机岂不是亏了（~~

## 准备

官网下载安装镜像[BlissOS](https://blissos.org/index.html#download)

我选择的是Zenith（基于最新版本）Gapps（谷歌全家桶）版

## 创建虚拟机

![1742427009470](image/index/1742427009470.png)

![1742427028737](image/index/1742427028737.png)

显卡记得选VIrGL GPU，否则进不去系统。新的pve需要`apt install libgl1 libegl1`

![1742427097994](image/index/1742427097994.png)

![1742427126740](image/index/1742427126740.png)

![1742427144050](image/index/1742427144050.png)

内存建议8G起步（玩游戏的话）4G能跑，之后一路下一步即可

![1742427253865](image/index/1742427253865.png)

## 安装

装之前可以进Live看一眼功能是否正常，我就不看了

![1742427359697](image/index/1742427359697.png)

### 分区

进入之后会到UEFI分区界面，需要创建两个分区

GPT格式

+ EFI（1G）
+ Linux Filesystem（剩下的空间）

![1742427403881](image/index/1742427403881.png)

选择cfdisk![1742427480868](image/index/1742427480868.png)

选择GPT![1742427504648](image/index/1742427504648.png)

使用New![1742427579797](image/index/1742427579797.png)创建两个分区

在第一个分区用![1742427613669](image/index/1742427613669.png)选择EFI system![1742427631549](image/index/1742427631549.png)

![1742427645743](image/index/1742427645743.png)

选择![1742427663166](image/index/1742427663166.png)，输入 `yes`完成分区

### 安装

以此选择第一个分区和第二个分区，每次都选择格式化，第二个格式化为ext4，期间所有提示都选择接受/OK即可

![1742427692628](image/index/1742427692628.png)

OTA更新（选No）谁家好人要电脑上装OTA啊（

![1742427842685](image/index/1742427842685.png)

引导选择rEFInd（我grub2用不了）

![1742427903079](image/index/1742427903079.png)

选择重启即可

![1742427941649](image/index/1742427941649.png)

![1742427964694](image/index/1742427964694.png)

### 可能的问题

有可能某些地方没设置好导致无法进入引导，可以一直插着ISO，然后在安装界面选择最下面的![1742428074771](image/index/1742428074771.png)

就可以成功进入引导了

## 启动

成功啦

![1742428345576](image/index/1742428345576.png)

![1742428593240](image/index/1742428593240.png)

![1742428610991](image/index/1742428610991.png)

非常可惜的是KernelSU烂掉了

scrcpy，非常流畅

![1742428878163](image/index/1742428878163.png)

## 修复root

![1742429421087](image/index/1742429421087.png)

### /system/bin/su

![1742429690558](image/index/1742429690558.png)

**It works on my machine ¯\\_(ツ)\_/¯**

![1742429705647](image/index/1742429705647.png)

### syscall_hardening=off(失败)

![1742429909039](image/index/1742429909039.png)

起一个进入 DEBUG live（假设你的ISO还没拔掉）

挂载 `/dev/sda1`到随便什么地方，找到 `android.cfg`

BlissOS（最外层）的 `options`加 `syscall_hardening=off`

![1742431802677](image/index/1742431802677.png)

还是不行，放弃

## 调整分辨率

rootshell 执行 `/system/bin/wmsize 900x1600` （绝对路径）

好啦，刷本吧，哈哈

## fin
