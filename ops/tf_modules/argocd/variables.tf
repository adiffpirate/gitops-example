variable "environment" {
  description = "Environment"
  type        = string
}

variable "namespace" {
  description = "Kubernetes Namespace where ArgoCD will be installed"
  type        = string
  default     = "argocd"
}
