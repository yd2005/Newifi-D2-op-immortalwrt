#!/bin/bash
# diy-part2-newifi3.sh

# 1. 设置管理 IP (可选)
sed -i 's/192.168.1.1/192.168.1.1/g' package/base-files/files/bin/config_generate

# 2. 暴力删除无线驱动 (保留 iwinfo 库!)
# ⚠️ 注意：不要删除 package/network/utils/iwinfo，rpcd 服务依赖它
rm -rf package/kernel/mt76
rm -rf package/network/services/hostapd
# rm -rf package/network/utils/iwinfo  <-- 这行千万不能有，已注释掉

# 3. 正确安装 Nikki (使用 Git Clone 方式)
git clone https://github.com/nikki-dev/luci-app-nikki.git package/luci-app-nikki

# 4. 极限压缩 (Tailscale & Mihomo)
sudo apt-get install -y upx-ucl
# 压缩 Tailscale
upx --best --ultra-brute feeds/packages/net/tailscale/files/tailscale* 2>/dev/null || true
# 压缩 Mihomo (Nikki 的核心)
upx --best --ultra-brute feeds/packages/net/mihomo/files/mihomo* 2>/dev/null || true
# 以防万一，扫描整个 feeds 目录下的 mihomo 二进制
find feeds -name "mihomo" -type f -exec upx --best --ultra-brute {} \; 2>/dev/null || true
