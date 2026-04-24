data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket         = "dev-eks-cluster-tf-state"   # S3 bucket where network state is stored
    key            = "2-eks-cluster/terraform.tfstate" # path inside the bucket
    region         = "us-east-2"                 # AWS region
    dynamodb_table = "dev-eks-cluster-table-tf-lock"    # DynamoDB table for state locking
  }
}