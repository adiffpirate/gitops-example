variable "project" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = null
}

variable "cluster_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.24`)"
  type        = string
  default     = null
}

variable "managed_node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type        = any
  default     = {}
}

variable "public_access" {
  description = "EXTREMELY DANGEROUS: Determines whether the EKS Control Plane should be accessible over the internet. Should not be enabled in production"
  type        = bool
  default     = false
}

variable "aws_auth_extra_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_extra_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_extra_accounts" {
  description = "List of account maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "log_retention_period" {
  description = "Number of days to retain log events"
  type        = number
  default     = 90
}

variable "cluster_autoscaler_custom_values" {
  description = "Values to customize the Cluster Autoscaler Helm Release (should be an YAML heredoc)"
  type        = string
  default     = ""
}

variable "tags_get_vpc" {
  description = "Tags used to get the VPC (shuld match only one VPC)"
  type        = map(string)
}

variable "tags_get_subnets" {
  description = "Tags used to get the list of subnets where the cluster and instances will be created"
  type        = map(string)
}
