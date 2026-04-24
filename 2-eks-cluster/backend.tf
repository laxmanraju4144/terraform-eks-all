data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket         = "dev-eks-cluster-tf-state"   # S3 bucket where network state is stored
    key            = "1-network/terraform.tfstate" # path inside the bucket
    region         = "ap-south-1"                 # AWS region
    dynamodb_table = "dev-eks-cluster-table-tf-lock"    # DynamoDB table for state locking
  }
}