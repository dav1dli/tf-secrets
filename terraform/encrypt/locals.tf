locals {
  resource_group  = "RG-${var.region}-${var.environment}-${var.project}"
  kv_name         = "KV-${var.region}-${var.environment}-${var.project}"
  db_name         = lower("DB-${var.region}-${var.environment}-${var.project}")
}