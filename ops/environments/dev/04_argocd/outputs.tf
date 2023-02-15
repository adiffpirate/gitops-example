output "namespace" {
  description = "Kubernetes Namespace where ArgoCD was installed"
  value       = module.argocd.namespace
}
