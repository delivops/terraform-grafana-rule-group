module "EC2-alarms" {
  source             = "../"
  folder_name        = "EC2-alerts"
  datasource_names   = ["Virginia", "Ireland"]
  static_rule_groups = yamldecode(templatefile("EC2-alarms.yaml", {}))

}