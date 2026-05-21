# Deploy

本仓承载 byte-v-forge 的部署入口、IaC、环境示例和部署辅助脚本。

## 目录

- `docker-compose.yml`：本地或远程 Docker Compose 部署入口。
- `.env.example`：部署变量示例。
- `iac/helm/byte-v-forge/`：Kubernetes Helm chart。
- `scripts/deploy-remote.sh`：远程构建、导入镜像和 Helm 升级脚本。
- `scripts/logs-remote.sh`：远程 Kubernetes 日志查看脚本。

WebUI、mailbox webhook 和 GoPay OTP webhook 的外部 HTTP 入口通过 Helm `ingress` 配置。`ingress.webhook` 按路径把 `/webhooks/email` 分发到 mailbox，把 GoPay OTP 路径分发到 gpt-service。需要公网 mailbox webhook 时启用 `workloads.cloudflare-tunnel`，把 Cloudflare Tunnel token 写入 `secrets.stringData.CLOUDFLARE_TUNNEL_TOKEN`，并只在 Cloudflare Tunnel 上放行 `/webhooks/email/` 前缀。
Cloudflare 邮箱域名通过 Helm `cloudflareEmail` 声明 zones，并由 mailbox 使用 `MAILBOX_CLOUDFLARE_API_TOKEN` 从 Cloudflare Email Routing catch-all 规则与 MX DNS 配置推导；不在 values 里手填邮箱 domains。该 token 限制到目标 zone，并授予 `Zone Read`、`DNS Read` 和 `Email Routing Rules Read` 即可。

## Helm 渲染

```sh
helm lint iac/helm/byte-v-forge
helm template byte-v-forge iac/helm/byte-v-forge --namespace byte-v-forge >/tmp/byte-v-forge.yaml
```

## 远程部署

```sh
scripts/deploy-remote.sh all
```

部署脚本默认从本仓父目录读取 sibling 目标仓源码，例如 `gpt/`、`mailbox/`、`sms/`、`browser-automation/` 和 `webui/`，并同步到远程构建目录。可通过 `SOURCE_ROOT` 指定源码父目录。
`workflow-runtime/` 作为 workflow runtime 边界组件同步并部署，业务服务通过它连接运行时。
部署脚本默认使用远程宿主机和 `byte-v-forge` Helm release，可通过脚本参数或环境变量覆盖。
`browser-automation` 使用独立 runtime base 镜像承载 Camoufox、Playwright、GeoIP 和浏览器资源；常规业务部署只重建服务二进制层。远程镜像导入默认先尝试宿主机本地 registry 分层导入，失败后才回退到 qemu guest agent tar 导入。registry 端口可通过 `DEPLOY_REGISTRY_PUSH_ADDR` 和 `DEPLOY_REGISTRY_PULL_ADDR` 覆盖。

## 日志

```sh
scripts/logs-remote.sh gpt-service
scripts/logs-remote.sh -f all
```
