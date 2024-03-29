terraform {
  required_version = ">= 1.3.5"

  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}
