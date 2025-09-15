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

variable "github_org" { 
type = string 
}

variable "github_repo" { 
type = string 
}


