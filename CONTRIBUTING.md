# 贡献指南

## 边界

本仓接收部署入口、IaC、环境示例、部署脚本和基础镜像定义。

部署变量变更需要同步检查：

- `docker-compose.yml`
- `iac/helm/nb-register/values.yaml`
- `iac/helm/nb-register/templates/`
- `.env.example`
- `scripts/`

## 验证

```sh
bash -n scripts/deploy-remote.sh scripts/logs-remote.sh
helm lint iac/helm/nb-register
helm template nb-register iac/helm/nb-register --namespace nb-register >/tmp/nb-register.yaml
docker compose --env-file .env.example config >/tmp/nb-register-compose.yaml
```
