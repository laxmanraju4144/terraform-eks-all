variable "project" {
  type    = string
  default = "dev-eks-cluster"
}

variable "kubernetes_version" {
  type    = string
  default = "1.30"
}

variable "ssh_key_name" {
  type        = string
  description = "This is for Dev Environments"
  default     = "Common"
}

variable "cluster_name" {
  type    = string
  default = "dev-eks-cluster"
}