terraform {
  backend "s3" {
    region         = "us-west-1"
    bucket         = "gitops-example-dev-terraform-state"
    key            = "04_argocd/terraform.state"
    dynamodb_table = "gitops-example-dev-terraform-state-lock"
  }

  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

provider "kubectl" {
  config_path = "~/.kube/config"
}

module "argocd" {
  source = "../../../tf_modules/argocd"

  environment   = "dev"
  microservices = [
    "api",
    "webapp"
  ]
}
