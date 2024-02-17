terraform {
  backend "kubernetes" {
    secret_suffix = "argocd"
    config_path   = "~/.kube/config"
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

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "argocd" {
  source = "../../../tf_modules/argocd"

  environment  = "dev"
  applications = [
    "api",
    "webapp"
  ]
}
