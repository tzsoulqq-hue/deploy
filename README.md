# base-images

Byte V Forge 服务共享的容器基础镜像定义仓。

## 职责

- 维护通用构建镜像和运行时镜像模板。
- 为业务镜像提供 Go、Node 和浏览器自动化运行时基础。
- 业务镜像可以基于本仓模板构建。
- 实际镜像构建目标为约定的远程构建环境或 CI。

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

CI 会验证 Dockerfile 可解析，并执行本地构建检查。
