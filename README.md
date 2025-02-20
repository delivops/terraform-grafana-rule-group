# terraform-grafana-rule-group
This repo knows to get yaml file that represents rules for grafana, and create it using terraform.

## Overview
This Terraform module allows you to define and manage Grafana rule groups from YAML files. It automates the creation of rule groups within a specified Grafana folder, ensuring structured and maintainable alerting configurations.

## Features
- Creates a Grafana folder for organization.
- Defines multiple rule groups dynamically based on input YAML configuration.
- Supports setting intervals for rule evaluation.
- Configures rules with conditions, annotations, labels, and notification settings.
- Allows fine-grained control over alerting parameters, including execution error handling and data states.

## Requirements
- Terraform 1.0+
- Grafana provider for Terraform
- Grafana instance with API access


## Example Usage

```hcl
module "EC2-alarms" {
  source = "../../modules/grafana-rule-group"
  #version = xxx

  folder_name        = "EC2-alerts"
  datasource_uid     = local.cloudwatch_datasource_uid
  static_rule_groups = yamldecode(file("EC2-alarms.yaml"))
  rule_groups        = {}
}
