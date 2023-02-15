variable "namespace" {
  description = "Kubernetes Namespace where ArgoCD will be installed"
  type        = string
  default     = "argocd"
}
