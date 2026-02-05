#!/bin/bash
# diy-part2-newifi3.sh

# 1. 设置管理 IP
sed -i 's/192.168.1.1/192.168.1.1/g' package/base-files/files/bin/config_generate

# 2. 这里的删除要非常小心！
# 删除无线驱动源码（省空间，安全）
rm -rf package/kernel/mt76
# 删除 hostapd（AP守护进程，省空间，安全）
rm -rf package/network/services/hostapd
# ⚠️ 绝对不要删除 iwinfo，否则系统基础服务 rpcd 编译会挂！

# 3. 正确安装 Nikki (使用 Git Clone 方式)
git clone https://github.com/nikki-dev/luci-app-nikki.git package/luci-app-nikki

# 4. 极限压缩 (Tailscale & Mihomo) - 32MB 救星
sudo apt-get install -y upx-ucl
# 压缩 Tailscale
upx --best --ultra-brute feeds/packages/net/tailscale/files/tailscale* 2>/dev/null || true
# 压缩 Mihomo (Nikki 的核心)
upx --best --ultra-brute feeds/packages/net/mihomo/files/mihomo* 2>/dev/null || true
# 再次兜底扫描压缩
find feeds -name "mihomo" -type f -exec upx --best --ultra-brute {} \; 2>/dev/null || true
