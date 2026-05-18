# syntax=docker/dockerfile:1.18
ARG BROWSER_RUNTIME_IMAGE=debian:bookworm-slim
FROM ${BROWSER_RUNTIME_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      chromium \
      fonts-liberation \
      fonts-noto-color-emoji \
      tzdata \
      xdg-utils \
    && groupadd --system --gid 10001 browser \
    && useradd --system --uid 10001 --gid browser --home-dir /home/browser --create-home --shell /bin/bash browser \
    && rm -rf /var/lib/apt/lists/*

USER 10001:10001
WORKDIR /workspace
