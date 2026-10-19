variable "name_prefix" {
  description = "A name to prefix resources with"
  type        = string
}

variable "application_name" {
  description = "The name of the application for this dashboard"
  type        = string
}

variable "display_name_override" {
  description = "Optional display name for the dashboard, overrides the default name (variable application_name) if set"
  type        = string
  default     = null
}

variable "environment" {
  description = "The environment that the application is launched in"
  type        = string
}

/*
 * == Services for the dashboards
 */
variable "ecs_cluster" {
  description = "Name of the ECS Cluster to create dashboards from"
  type        = string

  default = null
}

variable "rds_instance" {
  description = "RDS Instances to create dashboards from"
  type        = string

  default = null
}

variable "sns_topics" {
  description = "ARNs of SNS Topics to create dashboards from"
  type        = list(string)

  default = []
}

variable "sqs_queues" {
  description = "ARNs of SQS Queues to create dashboards from"
  type        = list(string)

  default = []
}

variable "s3_buckets" {
  description = "ARNs of S3 Buckets to create dashboards from"
  type        = list(string)

  default = []
}

variable "elasticache_group" {
  description = "Elasticache Groups to create dashboards from"
  type        = string

  default = null
}
