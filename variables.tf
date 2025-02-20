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

variable "datasource_uid" {
  type    = string
  default = ""
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
}

locals {
  expression_datasource_uid = -100
}
