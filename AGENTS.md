# AGENTS.md

本仓是 `deploy` 部署仓。

- 本仓承载 Docker Compose、Helm chart、部署 values、环境示例和部署脚本。
- 不提交真实 secret、真实账号、真实 token、真实代理凭据或真实会话材料。
- `.env.example` 和 values 示例只放占位值或虚构值。
- Helm 变更需要通过 `helm lint` 和 `helm template` 做非测试类检查。
- 脚本变更需要通过 `bash -n` 做语法检查。
- 本仓不维护 CI/CD 配置，不新增 `.github/`、GitLab CI、Jenkins、Dependabot 等自动化流水线配置。
- Mac 本机不作为业务镜像构建环境；真实镜像构建、导入和部署动作使用远程宿主机。
