# --- Vars ---
variable "ACCOUNT_ID" {}
variable "AWS_REGION" {}
variable "REPO_NAME"  {}
variable "TAG"        { default = "dev" }
variable "PLATFORMS"  { default = "linux/amd64" }

variable "REGISTRY"   { default = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com" }
variable "REPOSITORY" { default = "${REPO_NAME}" }

# --- Build target (no push) ---
target "app" {
  context    = "."
  dockerfile = "Dockerfile"

  # turn "linux/amd64,linux/arm64" into ["linux/amd64","linux/arm64"]
  platforms  = [for p in split(PLATFORMS, ",") : trimspace(p)]

  tags = ["${REGISTRY}/${REPOSITORY}:${TAG}"]

  # simple, reliable caching to start
  cache-from = ["type=inline"]
  cache-to   = ["type=inline"]
}

# --- Release (push) ---
target "app-release" {
  inherits = ["app"]
  push     = true
}

group "release" {
  targets = ["app-release"]
}

