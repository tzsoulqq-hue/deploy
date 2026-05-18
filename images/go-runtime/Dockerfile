# syntax=docker/dockerfile:1.18
ARG GO_RUNTIME_IMAGE=debian:bookworm-slim
FROM ${GO_RUNTIME_IMAGE}

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates tzdata \
    && groupadd --system --gid 10001 app \
    && useradd --system --uid 10001 --gid app --home-dir /nonexistent --shell /usr/sbin/nologin app \
    && rm -rf /var/lib/apt/lists/*

USER 10001:10001
WORKDIR /app
