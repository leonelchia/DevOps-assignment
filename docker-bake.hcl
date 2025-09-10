# docker-bake.hcl — ECR-focused Buildx Bake

# -------- Variables (override via env or --set) --------
variable "ACCOUNT_ID" {}
variable "AWS_REGION" {}
variable "REPO_NAME" {}

# Optional overrides
variable "TAG"       { default = "dev" }          # e.g., sha-<short>, dev, main
variable "PLATFORMS" { default = "linux/amd64" }  # add linux/arm64 if needed

# Derived values
variable "REGISTRY"   { default = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com" }
variable "REPOSITORY" { default = "${REPO_NAME}" }

# -------- Groups --------
group "default" { targets = ["app"] }
group "release" { targets = ["app-release"] }

# -------- Targets --------
target "app" {
  context    = "."
  dockerfile = "Dockerfile"

  # Multi-arch (simple split)
  platforms = split(PLATFORMS, ",")

  # Local/dev tag (even if not pushing)
  tags = [
    "${REGISTRY}/${REPOSITORY}:${TAG}"
  ]

  # Registry cache
  cache-from = [
    "type=registry,ref=${REGISTRY}/${REPOSITORY}:cache"
  ]
  cache-to = [
    "type=registry,ref=${REGISTRY}/${REPOSITORY}:cache,mode=max"
  ]
}

target "app-release" {
  inherits = ["app"]
  push     = true
  tags = [
    "${REGISTRY}/${REPOSITORY}:${TAG}"
  ]
}
