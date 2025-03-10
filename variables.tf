variable "folder_name" {
  type = string
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "annotations" {
  type    = map(string)
  default = {}
}

variable "datasource_names" {
  type    = list(string)
}

variable "static_rule_groups" {
  type = any
}

variable "datasource_type" {
  type    = string
  default = "cloudwatch"
}

variable "rule_groups" {
  type = any
  default = {}
}
locals {
  expression_datasource_uid = -100
}
variable "create_folder" {
  description = "Whether to create a new folder or use an existing one with the same name"
  type        = bool
  default     = true
}