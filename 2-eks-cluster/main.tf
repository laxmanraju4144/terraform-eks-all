locals {
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
  public_subnet_ids = data.terraform_remote_state.network.outputs.public_subnet_ids
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~>20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnet_ids

  # Endpoints access
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # Enable cluster creator admin permissions
  enable_cluster_creator_admin_permissions = true

  # Manage node groups with Terraform
  eks_managed_node_groups = {
    default = {
      desired_capacity = 3
      max_capacity     = 5
      min_capacity     = 3
      instance_types   = ["c7i-flex.large"]

      subnet_ids = local.private_subnet_ids

      remote_access = {
        ec2_ssh_key                = var.ssh_key_name
        source_security_group_ids = []
      }
    }
  }

  tags = {
    Project = var.project
  }
}

