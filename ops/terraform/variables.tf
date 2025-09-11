variable "region" {
  type    = string
  default = "eu-north-1"
}

variable "cluster_name" {
  type    = string
  default = "demo-eks"
}

variable "ecr_repo_name" {
  type    = string
  default = "springboot-k8s-demo"
}

variable "name_prefix" {
  type    = string
  default = "springboot-k8s"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile to use for local development"
  default     = "dev-admin" #  use locally
}


variable "github_org" { type = string }
variable "github_repo" { type = string }

# If you don't have GH OIDC provider, create it; otherwise pass the ARN here.
#variable "github_oidc_provider_arn" { type = string }
