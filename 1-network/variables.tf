
variable "project" {
  description = "dev-microservices-eks-cluster"
  type        = string
  default     = "dev-microservices-eks-cluster"
}


variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}


variable "azs" {
    description = "List of availability zones to use for subnets"
    type        = list(string)
    default     = ["us-east-2a", "us-east-2b"]
}