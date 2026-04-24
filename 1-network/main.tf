# -----------------------------
# Fetch available AWS AZs
# -----------------------------
data "aws_availability_zones" "available" {}

# -----------------------------
# Local values (shortcuts)
# -----------------------------
locals {
  azs  = var.azs
  tags = {
    Project = var.project
  }
}

