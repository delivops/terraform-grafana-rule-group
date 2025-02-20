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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | >=3.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_grafana"></a> [grafana](#provider\_grafana) | >=3.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [grafana_folder.this](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/folder) | resource |
| [grafana_rule_group.this](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | n/a | `map(string)` | `{}` | no |
| <a name="input_datasource_type"></a> [datasource\_type](#input\_datasource\_type) | n/a | `string` | `"cloudwatch"` | no |
| <a name="input_datasource_uid"></a> [datasource\_uid](#input\_datasource\_uid) | n/a | `string` | `""` | no |
| <a name="input_folder_name"></a> [folder\_name](#input\_folder\_name) | n/a | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | `map(string)` | `{}` | no |
| <a name="input_rule_groups"></a> [rule\_groups](#input\_rule\_groups) | n/a | `any` | n/a | yes |
| <a name="input_static_rule_groups"></a> [static\_rule\_groups](#input\_static\_rule\_groups) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->