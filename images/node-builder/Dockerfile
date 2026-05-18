# syntax=docker/dockerfile:1.18
ARG NODE_BUILDER_IMAGE=node:lts-bookworm
FROM ${NODE_BUILDER_IMAGE}

ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

RUN corepack enable

WORKDIR /workspace
