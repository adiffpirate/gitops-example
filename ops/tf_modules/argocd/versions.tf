terraform {
  required_version = ">= 1.3.5"

  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}
