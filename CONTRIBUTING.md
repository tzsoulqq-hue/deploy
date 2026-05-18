# 贡献指南

## 边界

本仓只接收通用基础镜像定义。

以下内容不进入本仓：

- 业务服务 Dockerfile；
- 业务启动脚本；
- 真实环境变量、secret 或部署 values；
- 构建产物。

## 验证

```sh
docker buildx bake --file docker-bake.hcl --print
```
