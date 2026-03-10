# 🛡️ Caddy IP Redirector

> 一个极简、纯净的 Caddy IP 伪装与重定向防御脚本。

本项目旨在为裸露的服务器 IP 提供轻量级的 HTTP(80端口) 请求重定向服务。当扫描器或未知访客直接访问你的服务器公网 IP 时，Caddy 会将其无缝、永久(301)重定向到你指定的伪装域名，有效降低 IP 被主动探测的风险。

## ✨ 特性

- **轻量高效**：仅依赖官方 Caddy 作为核心组件，占用资源极低。
- **一键部署**：交互式填入伪装域名，全自动完成依赖安装、Caddy 部署及规则配置。
- **开箱即用**：无需手动修改配置文件，部署完毕即刻生效。

## ⚙️ 系统要求

- **操作系统**：Debian / Ubuntu (推荐使用纯净系统)
- **权限**：需要 `root` 权限
- **端口**：确保服务器的 `80` 端口未被其他程序（如 Nginx, Apache）占用

## 🚀 一键安装

使用 SSH 登录到你的服务器，并以 root 身份执行以下命令：

```bash
bash <(curl -sL [https://raw.githubusercontent.com/starshine369/caddy-ip-redirector/main/install.sh](https://raw.githubusercontent.com/starshine369/caddy-ip-redirector/main/install.sh))
