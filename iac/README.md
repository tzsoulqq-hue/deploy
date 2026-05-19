# Byte V Forge IaC

此目录承载 Kubernetes 安装变量和 Helm chart。集群变量统一写到 Helm values。

## 目录

```text
iac/
  helm/byte-v-forge/          # 主 Helm chart
    values.yaml              # 默认变量，非生产密钥仅作占位
    values.local.example.yaml
```

## 变量分层

- `configEnv`：非敏感运行参数，渲染为 ConfigMap。
- `secrets.stringData`：敏感参数，渲染为 Secret。
- `workloads`：每个服务的镜像、端口、探针、挂载和副本数。
- `ingress`：WebUI、mailbox webhook 和 GoPay OTP webhook 的外部入口。
- `workloads.ingress-frpc`：面向 ingress-nginx HTTP 入口的可选公网隧道。

Kubernetes 部署中的代理地址使用集群可达的 Service、内网 IP 或 egress proxy。

## 使用

```bash
cp iac/helm/byte-v-forge/values.local.example.yaml iac/helm/byte-v-forge/values.local.yaml
```

编辑 `values.local.yaml` 后验证：

```bash
helm version --short
helm lint iac/helm/byte-v-forge -f iac/helm/byte-v-forge/values.local.yaml
helm template byte-v-forge iac/helm/byte-v-forge \
  --namespace byte-v-forge \
  -f iac/helm/byte-v-forge/values.local.yaml \
  >/tmp/byte-v-forge.yaml
```

安装或升级：

```bash
helm upgrade --install byte-v-forge iac/helm/byte-v-forge \
  --namespace byte-v-forge \
  --create-namespace \
  --rollback-on-failure \
  --wait=watcher \
  --wait-for-jobs \
  --timeout 10m \
  -f iac/helm/byte-v-forge/values.local.yaml
```

验证：

```bash
helm status byte-v-forge -n byte-v-forge
kubectl -n byte-v-forge get pods,svc,pvc
kubectl -n byte-v-forge get events --sort-by=.lastTimestamp
```
