# Deploy

本仓承载 nb-register 的部署入口、IaC、环境示例和部署辅助脚本。

## 目录

- `docker-compose.yml`：本地或远程 Docker Compose 部署入口。
- `.env.example`：部署变量示例。
- `iac/helm/nb-register/`：Kubernetes Helm chart。
- `scripts/deploy-remote.sh`：远程构建、导入镜像和 Helm 升级脚本。
- `scripts/logs-remote.sh`：远程 Kubernetes 日志查看脚本。
- `docker/camoufox-base/`：浏览器注册运行所需基础镜像。
- `images/`：共享基础镜像定义。

## Helm 渲染

```sh
helm lint iac/helm/nb-register
helm template nb-register iac/helm/nb-register --namespace nb-register >/tmp/nb-register.yaml
```

## 远程部署

```sh
scripts/deploy-remote.sh all
```

部署脚本默认使用远程宿主机和 `nb-register` Helm release，可通过脚本参数或环境变量覆盖。

## 日志

```sh
scripts/logs-remote.sh orchestrator
scripts/logs-remote.sh -f all
```
