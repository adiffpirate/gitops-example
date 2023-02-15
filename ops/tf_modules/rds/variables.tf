variable "project" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "master_username" {
  description = "Name of the Master User"
  type        = string
  default     = "superuser"
}

variable "engine" {
  description = "The name of the database engine to be used for this DB cluster. Valid Values: `aurora-mysql`, `aurora-postgresql`"
  type        = string

  validation {
    condition     = var.engine == "aurora-mysql" || var.engine == "aurora-postgresql"
    error_message = "Engine must be one of the following: aurora-mysql, aurora-postgresql."
  }
}

variable "engine_version" {
  description = "The database engine version. Updating this argument results in an outage"
  type        = string
}

variable "azs" {
  description = "Availability Zones where the Aurora Cluster will be created"
  type        = list(string)
}

variable "one_instance_per_az" {
  description = "Determine if each AZ should have an Instance or if only Instance should be created"
  type        = string
  default     = true
}

variable "public_access" {
  description = "EXTREMELY DANGEROUS: Determines whether the Aurora Cluster should be accessible over the internet. Should not be enabled in production"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The amount of days to retain backups for"
  type        = string
}

variable "instance_type" {
  description = "The instance class to use. Aurora uses `db.*` instance classes/types"
  type        = string
}

variable "vpc_tags" {
  description = "Tags used to get the VPC (shuld match only one VPC)"
  type        = map(string)
}

variable "subnets_tags" {
  description = "Tags used to get the list of subnets where the cluster and instances will be created"
  type        = map(string)
}

variable "create_databases" {
  description = "List of databases names to be created once the Aurora Cluster is up. For each database an user (owner) will be created with the same name and a random password. Currently only supports PostgreSQL"
  type        = list(string)
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created. If false is specified, a DB snapshot is created before the DB cluster is deleted"
  type        = bool
  default     = false
}
