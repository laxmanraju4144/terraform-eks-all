terraform {
  backend "s3" {
    bucket = "dev-eks-cluster-tf-state"
    key = "laxman-eks-cluster/1-network/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "dev-eks-cluster-tf-lock"
    encrypt = true
  }
}