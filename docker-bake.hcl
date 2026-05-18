variable "GO_BUILDER_IMAGE" {
  default = "golang:1.26.3-bookworm"
}

variable "GO_RUNTIME_IMAGE" {
  default = "debian:bookworm-slim"
}

variable "NODE_BUILDER_IMAGE" {
  default = "node:lts-bookworm"
}

variable "BROWSER_RUNTIME_IMAGE" {
  default = "debian:bookworm-slim"
}

group "default" {
  targets = ["go-builder", "go-runtime", "node-builder", "browser-runtime"]
}

target "go-builder" {
  context = "."
  dockerfile = "images/go-builder/Dockerfile"
  args = {
    GO_BUILDER_IMAGE = GO_BUILDER_IMAGE
  }
  tags = ["byte-v-forge/go-builder:dev"]
}

target "go-runtime" {
  context = "."
  dockerfile = "images/go-runtime/Dockerfile"
  args = {
    GO_RUNTIME_IMAGE = GO_RUNTIME_IMAGE
  }
  tags = ["byte-v-forge/go-runtime:dev"]
}

target "node-builder" {
  context = "."
  dockerfile = "images/node-builder/Dockerfile"
  args = {
    NODE_BUILDER_IMAGE = NODE_BUILDER_IMAGE
  }
  tags = ["byte-v-forge/node-builder:dev"]
}

target "browser-runtime" {
  context = "."
  dockerfile = "images/browser-runtime/Dockerfile"
  args = {
    BROWSER_RUNTIME_IMAGE = BROWSER_RUNTIME_IMAGE
  }
  tags = ["byte-v-forge/browser-runtime:dev"]
}
