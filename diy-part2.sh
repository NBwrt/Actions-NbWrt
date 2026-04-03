#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
#

# 修改默认IP
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 修改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 修改主机名
sed -i 's/OpenWrt/RAX3000M/g' package/base-files/files/bin/config_generate

# 【关键修复】适配 mt7986 闭源驱动的清华源（原filogic源不匹配闭源版）
cat > package/base-files/files/etc/opkg/distfeeds.conf <<EOF
src/gz immortalwrt_core https://mirrors.tuna.tsinghua.edu.cn/immortalwrt/releases/24.10.5/targets/mediatek/mt7986/packages
src/gz immortalwrt_base https://mirrors.tuna.tsinghua.edu.cn/immortalwrt/releases/24.10.5/packages/aarch64_cortex-a53/base
src/gz immortalwrt_luci https://mirrors.tuna.tsinghua.edu.cn/immortalwrt/releases/24.10.5/packages/aarch64_cortex-a53/luci
src/gz immortalwrt_packages https://mirrors.tuna.tsinghua.edu.cn/immortalwrt/releases/24.10.5/packages/aarch64_cortex-a53/packages
src/gz immortalwrt_routing https://mirrors.tuna.tsinghua.edu.cn/immortalwrt/releases/24.10.5/packages/aarch64_cortex-a53/routing
src/gz immortalwrt_telephony https://mirrors.tuna.tsinghua.edu.cn/immortalwrt/releases/24.10.5/packages/aarch64_cortex-a53/telephony
EOF

# 内核优化 BBR + fq_codel
cat > package/base-files/files/etc/sysctl.conf <<EOF
net.core.default_qdisc=fq_codel
net.ipv4.tcp_congestion_control=bbr
net.ipv4.tcp_syncookies=1
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_fin_timeout=30
net.ipv4.tcp_keepalive_time=1200
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
vm.swappiness=10
vm.dirty_ratio=10
vm.dirty_background_ratio=5
kernel.panic=3
net.netfilter.nf_conntrack_max=65535
EOF

# 【关键修复】删除iStore开机自启（你要求删除iStore）
sed -i '/istoreos/d' package/base-files/files/etc/rc.local

# 拉取最新 OpenClash（避免版本冲突）
rm -rf feeds/luci/applications/luci-app-openclash
git clone --depth=1 https://github.com/vernesong/OpenClash.git package/luci-app-openclash
