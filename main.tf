terraform {
  required_version = ">= 1.0.0"

  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 1.12.0"
    }
  }
}

/*
 * == Folder
 *
 * This is where all resources will be created!
 */
resource "grafana_folder" "collection" {
  title = title("${var.name_prefix} > ${var.application_name} > ${var.environment}")
}

/*
 * == Dashboards
 */
resource "grafana_dashboard" "ecs_cluster" {
  count = var.ecs_cluster == null ? 0 : 1

  folder = grafana_folder.collection.id

  config_json = templatefile("${path.module}/grafana-templates/ecs-dashboard.tpl", {
    "name" : title("ECS ${var.name_prefix} ${var.application_name} ${var.environment}")
    "environment" : var.environment
    "name_prefix" : var.name_prefix
    "application" : var.application_name
    "service_name" : var.application_name
    "ecs_cluster" : var.ecs_cluster
    "region" : "eu-west-1"
    "uuid" : md5("ECS ${var.name_prefix} > ${var.application_name} > ${var.environment}")
  })
}

resource "grafana_dashboard" "rds_instances" {
  count  = var.rds_instance == null ? 0 : 1

  folder = grafana_folder.collection.id

  config_json = templatefile("${path.module}/grafana-templates/rds-dashboard.tpl", {
    "name" : title("RDS ${var.name_prefix} ${var.application_name} ${var.environment}")
    "environment" : var.environment
    "name_prefix" : var.name_prefix
    "application" : var.application_name
    "service_name" : var.application_name
    "db_instance_identifier" : var.rds_instance
    "region" : "eu-west-1"
    "uuid" : md5("RDS ${var.name_prefix} > ${var.application_name} > ${var.environment}")
  })
}

locals {
  sns_topics = [
    for arn in var.sns_topics :
    element(split(":", arn), length(split(":", arn)) - 1)
  ]
}

resource "grafana_dashboard" "sns_topics" {
  count  = length(local.sns_topics) > 0 ? 1 : 0

  folder = grafana_folder.collection.id

  config_json = templatefile("${path.module}/grafana-templates/sns-dashboard.tpl", {
    "name" : title("SNS ${var.name_prefix} ${var.application_name} ${var.environment}")
    "environment" : var.environment
    "name_prefix" : var.name_prefix
    "application" : var.application_name
    "service_name" : var.application_name
    "topic_name_filter" : "/(${join("|", local.sns_topics)})/"
    "region" : "eu-west-1"
    "uuid" : md5("SNS ${var.name_prefix} > ${var.application_name} > ${var.environment}")
  })
}

locals {
  sqs_queues = [
    for arn in var.sqs_queues :
    element(split(":", arn), length(split(":", arn)) - 1)
  ]
}

resource "grafana_dashboard" "sqs_queues" {
  count  = length(local.sqs_queues) > 0 ? 1 : 0

  folder = grafana_folder.collection.id

  config_json = templatefile("${path.module}/grafana-templates/sqs-dashboard.tpl", {
    "name" : title("SQS ${var.name_prefix} ${var.application_name} ${var.environment}")
    "environment" : var.environment
    "name_prefix" : var.name_prefix
    "application" : var.application_name
    "service_name" : var.application_name
    "queue_name_filter" : "/(${join("|", local.sqs_queues)})/"
    "region" : "eu-west-1"
    "uuid" : md5("SQS ${var.name_prefix} > ${var.application_name} > ${var.environment}")
  })
}

locals {
  s3_buckets = [
    for arn in var.s3_buckets :
    element(split(":", arn), length(split(":", arn)) - 1)
  ]
}
resource "grafana_dashboard" "s3_buckets" {
  count  = length(local.s3_buckets) > 0 ? 1 : 0

  folder = grafana_folder.collection.id

  config_json = templatefile("${path.module}/grafana-templates/s3-dashboard.tpl", {
    "name" : title("S3 ${var.name_prefix} ${var.application_name} ${var.environment}")
    "environment" : var.environment
    "name_prefix" : var.name_prefix
    "application" : var.application_name
    "service_name" : var.application_name
    "s3_bucket_name_filter" : "/(${join("|", local.s3_buckets)})/"
    "region" : "eu-west-1"
    "uuid" : md5("S3 ${var.name_prefix} > ${var.application_name} > ${var.environment}")
  })
}

resource "grafana_dashboard" "elasticache_group" {
  count  = var.elasticache_group == null ? 0 : 1

  folder = grafana_folder.collection.id

  config_json = templatefile("${path.module}/grafana-templates/elasticache-dashboard.tpl", {
    "name" : title("Elasticache ${var.name_prefix} ${var.application_name} ${var.environment}")
    "environment" : var.environment
    "name_prefix" : var.name_prefix
    "application" : var.application_name
    "service_name" : var.application_name
    "cache_name_filter" : "/(${var.elasticache_group}.*)/"
    "region" : "eu-west-1"
    "uuid" : md5("ELASTICACHE ${var.name_prefix} > ${var.application_name} > ${var.environment}")
  })
}
