# base-images

Byte V Forge 服务共享的容器基础镜像定义仓。

## 边界

- 本仓只维护通用构建镜像和运行时镜像模板。
- 本仓不放业务代码、业务配置、secret、应用启动脚本或部署 values。
- 业务镜像可以基于本仓模板构建；本仓不能依赖任何业务仓。
- Mac 本机不作为业务镜像构建目标；实际镜像构建应在约定的远程构建环境或 CI 中执行。

## 镜像目录

- `images/go-builder`：Go 构建环境。
- `images/go-runtime`：Go 服务运行时基础镜像。
- `images/node-builder`：前端构建环境。
- `images/browser-runtime`：浏览器自动化运行时基础镜像。

## 版本策略

镜像默认使用 `versions.env` 中的最新稳定/LTS 主线。升级时需要同步更新 README、CI 和构建命令示例。

## 验证

```sh
docker buildx bake --file docker-bake.hcl --print
```

CI 会验证 Dockerfile 可解析，并执行不推送的构建检查。
