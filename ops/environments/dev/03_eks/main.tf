terraform {
  backend "s3" {
    region         = "us-west-1"
    bucket         = "gitops-example-dev-terraform-state"
    key            = "03_eks/terraform.state"
    dynamodb_table = "gitops-example-dev-terraform-state-lock"
  }
}

provider "aws" {
  region  = "us-west-1"
  profile = "gitops-example-dev"
}

module "eks" {
  source  = "../../../tf_modules/eks"

  project     = "gitops-example"
  environment = "dev"
  region      = "us-west-1"

  cluster_version      = "1.24"
  log_retention_period = 7

  public_access = true # ATTENTION: For testing/demonstrations purposes only. SHOULD NOT BE USED IN PRODUCTION

  managed_node_groups = {
    default = {
      min_size = 1
      max_size = 10

      capacity_type  = "SPOT"
      instance_types = [
        "t3a.small",
        "t3a.medium",
        "t3.small",
        "t3.medium",
        "t2.medium",
      ]
    }
  }

  tags_get_vpc = {
    "environment" = "dev"
    "project"     = "gitops-example"
  }

  tags_get_subnets = {
    "environment" = "dev"
    "project"     = "gitops-example"
    "scope"       = "private"
  }
}
