---
title: "FFmpeg 透明 Gif"
description: "将png序列变为带透明通道的gif"
date: 2024-12-09T13:14:02+08:00
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
draft: true
---
```bash
ffmpeg -i %045.png -vf palettegen=reserve_transparent=1 palette.png
ffmpeg -framerate 30 -i %05d.png -i palette.png -lavfi paletteuse=alpha_threshold=128 -gifflags -offsetting out.gif
```