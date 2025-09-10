# docker-bake.hcl — Buildx Bake config (ECR-focused)

# -------- Variables (override via env or --set) --------
# Required for ECR:
#   ACCOUNT_ID, AWS_REGION, REPO_NAME
# Example:
#   ACCOUNT_ID=123456789012 AWS_REGION=eu-north-1 REPO_NAME=springboot-k8s-demo \
#   TAG=sha-abc1234 docker buildx bake release
variable "ACCOUNT_ID" {}
variable "AWS_REGION" {}
variable "REPO_NAME" {}

# Optional overrides
variable "TAG"       { default = "dev" }                 # e.g., sha-<short>, dev, main
variable "PLATFORMS" { default = "linux/amd64" }         # add linux/arm64 if needed

# Derived values (don’t override)
variable "REGISTRY"   { default = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com" }
variable "REPOSITORY" { default = "${REPO_NAME}" }

# -------- Targets --------

# Default group builds (no push) — useful for fast local builds
group "default" {
  targets = ["app"]
}

# Release group pushes immutable tags to ECR
group "release" {
  targets = ["app-release"]
}

# Base image build definition
target "app" {
  context   = "."
  dockerfile = "Dockerfile"

  # Multi-arch
  platforms = [ split(PLATFORMS, ",")... ]

  # Tag used when not pushing (local dev)
  tags = [
    "${REGISTRY}/${REPOSITORY}:${TAG}",
  ]

  # Registry cache to speed up CI & local repeat builds
  cache-from = [
    "type=registry,ref=${REGISTRY}/${REPOSITORY}:cache"
  ]
  cache-to = [
    "type=registry,ref=${REGISTRY}/${REPOSITORY}:cache,mode=max"
  ]
}

# Release variant: same build, but pushes to ECR with the chosen TAG
target "app-release" {
  inherits = ["app"]
  push     = true
  tags = [
    "${REGISTRY}/${REPOSITORY}:${TAG}"
    # Optionally also push a floating tag (uncomment if you want it):
    # "${REGISTRY}/${REPOSITORY}:latest"
  ]
}
