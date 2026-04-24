terraform {
  backend "s3" {
    bucket = "dev-eks-cluster-tf-state"
    key = "laxman-eks-cluster/2-eks-cluster/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "dev-eks-cluster-table-tf-lock"
    encrypt = true
  }
}