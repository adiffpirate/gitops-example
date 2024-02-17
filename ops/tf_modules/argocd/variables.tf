variable "environment" {
  description = "Environment"
  type        = string
}

variable "namespace" {
  description = "Kubernetes Namespace where ArgoCD will be installed"
  type        = string
  default     = "argocd"
}

variable "applications" {
  description = "Applications to deploy. Its Helm Chart should be at `dev/{application}/chart` and the values file at `/ops/environments/{environment}/05_applications/{application}_values.yaml`"
  type        = list(string)
}

variable "applications_namespace" {
  description = "Namespace where the applications will be deployed"
  type        = string
  default     = "app"
}

variable "smtp_server" {
  description = "SMTP server to use when sending emails"
  type        = string
}

variable "alert_email" {
  description = "Email where alerts should be sent to"
  type        = string
}
