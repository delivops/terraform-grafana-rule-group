module "EC2-alarms" {
  source = "../../modules/grafana-rule-group"
  #version = xxx

  folder_name        = "EC2-alerts"
  datasource_uid     = local.cloudwatch_datasource_uid
  static_rule_groups = yamldecode(file("EC2-alarms.yaml"))
  rule_groups        = {}
}