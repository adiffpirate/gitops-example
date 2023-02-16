variable "environment" {
  description = "Environment"
  type        = string
}

variable "namespace" {
  description = "Kubernetes Namespace where ArgoCD will be installed"
  type        = string
  default     = "argocd"
}

variable "microservices" {
  description = "Microservices to deploy. Its Helm Chart should be at `dev/{microservice}/chart` and the values file at `/ops/environments/{environment}/05_application/{microservice}_values.yaml`"
  type        = list(string)
}

variable "microservices_namespace" {
  description = "Namespace where the microservices will be deployed"
  type        = string
  default     = "app"
}
