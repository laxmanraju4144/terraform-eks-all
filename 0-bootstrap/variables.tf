variable "aws_region" {
  description = "dev-EKS cluster"
  type        = string
  default     = "us-east-2"
}
variable "bucket_name" {
  description = "dev-eks-cluster-tf-state"
  type        = string
  default     = "dev-eks-cluster-tf-state"
  
}

variable "lock_table_name" {
  description = "dev-eks-cluster-tf-lock"
  type        = string
  default     = "dev-eks-cluster-tf-lock"
  
}