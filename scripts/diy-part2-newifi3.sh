#!/bin/bash
# diy-part2-newifi3.sh

# 1. 设置默认管理 IP (可选，这里设为 192.168.1.1)
sed -i 's/192.168.1.1/192.168.1.1/g' package/base-files/files/bin/config_generate

# 2. 暴力删除无线驱动源码
# 这比在 config 里取消勾选更彻底，确保编译过程中不会意外生成无线相关的冗余文件
rm -rf package/kernel/mt76
rm -rf package/network/services/hostapd
rm -rf package/network/utils/iwinfo

# 3. 尝试使用 UPX 压缩 Tailscale (如果有预编译二进制)
# Newifi3 空间太小，如果能压缩会更稳。如果找不到文件，这两行命令会静默失败，不影响编译。
# 注意：这通常针对的是 feeds 里下载下来的预编译二进制
# upx --best --ultra-brute feeds/packages/net/tailscale/files/tailscale* 2>/dev/null || true

# 4. 修复/调整 Nikki 依赖 (防止某些固件默认没有 nftables/tproxy 模块)
# ImmortalWrt 23.05 通常默认支持，此步骤作为保险
echo "CONFIG_PACKAGE_kmod-nft-tproxy=y" >> .config
