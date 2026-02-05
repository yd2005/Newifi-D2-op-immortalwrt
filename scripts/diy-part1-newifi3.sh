#!/bin/bash
# diy-part1-newifi3.sh

# 添加 Nikki 源
echo 'src-git nikki https://github.com/nikki-dev/luci-app-nikki' >> feeds.conf.default

# 可以在这里添加其他源，例如 Passwall 或 SSR+，但基于你的需求 Nikki 已足够
