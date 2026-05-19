# Deploy

本仓承载 byte-v-forge 的部署入口、IaC、环境示例和部署辅助脚本。

## 目录

- `docker-compose.yml`：本地或远程 Docker Compose 部署入口。
- `.env.example`：部署变量示例。
- `iac/helm/byte-v-forge/`：Kubernetes Helm chart。
- `scripts/deploy-remote.sh`：远程构建、导入镜像和 Helm 升级脚本。
- `scripts/logs-remote.sh`：远程 Kubernetes 日志查看脚本。

WebUI、mailbox webhook 和 GoPay OTP webhook 的外部 HTTP 入口通过 Helm `ingress` 配置。`ingress.webhook` 按路径把 `/webhooks/email`、`/webhooks/microsoft-graph` 分发到 mailbox，把 GoPay OTP 路径分发到 gpt-service。公网隧道可启用 `workloads.ingress-frpc`，并通过 `INGRESS_FRPC_CONFIG` 指向 ingress-nginx HTTP 入口。

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

## 日志

```sh
scripts/logs-remote.sh gpt-service
scripts/logs-remote.sh -f all
```
