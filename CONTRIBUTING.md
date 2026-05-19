# 贡献指南

## 边界

本仓接收部署入口、IaC、环境示例和部署脚本。

部署变量变更需要同步检查：

- `docker-compose.yml`
- `iac/helm/byte-v-forge/values.yaml`
- `iac/helm/byte-v-forge/templates/`
- `.env.example`
- `scripts/`

## 验证

```sh
bash -n scripts/deploy-remote.sh scripts/logs-remote.sh
helm lint iac/helm/byte-v-forge
helm template byte-v-forge iac/helm/byte-v-forge --namespace byte-v-forge >/tmp/byte-v-forge.yaml
docker compose --env-file .env.example config >/tmp/byte-v-forge-compose.yaml
```
