#!/bin/bash

# ====================================================
# Caddy 纯伪装重定向一键脚本 (无证书版)
# 适用系统：Debian / Ubuntu
# ====================================================

set -e

# 🛡️ 0. Root 权限检查
if [[ $EUID -ne 0 ]]; then
   echo "❌ 错误：请以 root 权限运行此脚本！"
   exit 1
fi

# 🔍 1. 自动检测环境与 IP
echo "🔍 正在进行系统环境测绘..."
SERVER_IP=$(curl -s https://api.ipify.org || curl -s https://ifconfig.me)
if [ -z "$SERVER_IP" ]; then
    echo "❌ 错误：无法获取公网 IP，请检查网络连接。"
    exit 1
fi

# 📧 2. 交互式获取伪装信息
echo "----------------------------------------------------"
printf "🌐 请输入伪装域名 [默认: www.tesla.com]: "
read -r FAKE_DOMAIN </dev/tty

# 如果用户未输入内容，则默认赋予 www.tesla.com
FAKE_DOMAIN=${FAKE_DOMAIN:-www.tesla.com}

echo "----------------------------------------------------"
echo "🚀 目标 IP: $SERVER_IP"
echo "🌐 伪装目标: $FAKE_DOMAIN"
echo "----------------------------------------------------"
printf "确认以上信息无误？(y/n): "
read -r CONFIRM </dev/tty

if [ "$CONFIRM" != "y" ]; then
    echo "❌ 操作取消。"
    exit 1
fi

# 🛠️ 3. 环境依赖安装
echo "--- 正在安装环境依赖 ---"
apt update && apt install -y curl sudo debian-keyring debian-archive-keyring apt-transport-https

# 🧠 4. 部署 Caddy 门卫
echo "--- 正在部署 Caddy 伪装防御体系 ---"
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update && sudo apt install caddy -y

# 写入纯净版 Caddy 重定向规则
sudo cat > /etc/caddy/Caddyfile << EOF
:80 {
    # 伪装通道：所有 HTTP 请求统统永久重定向 (301) 到您指定的伪装域名
    handle {
        redir https://$FAKE_DOMAIN{uri} permanent
    }
}
EOF

sudo systemctl enable --now caddy
sudo systemctl restart caddy

echo "----------------------------------------------------"
echo "✅ 伪装防御体系部署完毕！"
echo "🌐 伪装跳转生效: http://$SERVER_IP -> https://$FAKE_DOMAIN"
echo "----------------------------------------------------"
