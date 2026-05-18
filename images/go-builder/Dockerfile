# syntax=docker/dockerfile:1.18
ARG GO_BUILDER_IMAGE=golang:1.26.3-bookworm
FROM ${GO_BUILDER_IMAGE}

ENV CGO_ENABLED=0 \
    GOFLAGS="-buildvcs=false"

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git tzdata \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
