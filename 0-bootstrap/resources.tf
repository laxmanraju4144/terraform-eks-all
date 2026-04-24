resource "aws_s3_bucket" "tf_state" {
  bucket = var.bucket_name
  tags = {
    Name        = "dev-eks-cluster-tf-state"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_acl" "tf_state_acl" {
  bucket = aws_s3_bucket.tf_state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_account_public_access_block" "tf_state" {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tf_lock" {
   name = var.lock_table_name
   billing_mode = "PAY_PER_REQUEST"
   hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
}