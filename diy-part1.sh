#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
#

# 【关键修复】删除所有 iStore 相关源（你要求删除iStore）
sed -i '/istore/d' feeds.conf.default

# 【关键修复】只保留必需源，删除冗余nas源（避免找不到目录）
# 注释掉nas源，因为你已经删除iStore，不需要nas依赖
# echo 'src-git nas https://github.com/linkease/nas-packages.git;main' >> feeds.conf.default
# echo 'src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main' >> feeds.conf.default

# 启用 helloworld 源（OpenClash 必需）
sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# 【可选】如果需要OpenList，添加对应源（按需开启）
echo 'src-git openlist https://github.com/immortalwrt/openwrt-openlist.git;main' >> feeds.conf.default
