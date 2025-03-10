resource "grafana_folder" "this" {
  count = var.create_folder ? 1 : 0
  title = var.folder_name
}
data "grafana_folder" "existing" {
  count = var.create_folder ? 0 : 1
  title = var.folder_name
}

locals {
  datasource_uids = {
    for name, ds in data.grafana_data_source.this : name => ds.uid
  }
  duration_multiplier = {
    "s" = 1
    "m" = 60
    "h" = 60 * 60
    "d" = 60 * 60 * 24
  }
}

data "grafana_data_source" "this" {
  for_each = toset(var.datasource_names) # List of data source names
  name     = each.value
}


resource "grafana_rule_group" "this" {
  for_each   = { for group in var.static_rule_groups.groups : group.name => group }
  name       = each.value.name
  folder_uid = var.create_folder ? grafana_folder.this[0].uid : data.grafana_folder.existing[0].uid
  interval_seconds = sum(
    [
      for duration in regexall("([0-9]+)([a-z]+)", each.value.interval) : duration[0] * local.duration_multiplier[duration[1]]
    ]
  )
  disable_provenance = !try(each.value.enable_edit, false)

  dynamic "rule" {
    for_each = {
      for item in flatten([
        for rule in each.value.rules : [
          for ds_name in var.datasource_names : {
            key     = "${rule.title}-${ds_name}"
            title   = "${rule.title} (${ds_name})"
            rule    = rule
            ds_name = ds_name
          }
        ]
      ]) : item.key => item
    }
    iterator = rule_item
    content {
      name           = rule_item.value.title
      condition      = rule_item.value.rule.condition
      no_data_state  = rule_item.value.rule.noDataState
      exec_err_state = rule_item.value.rule.execErrState
      for            = rule_item.value.rule.for
      annotations = merge(
        try(rule_item.value.rule.annotations, null),
        try(var.annotations, null),
        try(var.rule_groups.annotations, null),
        try(var.rule_groups.rule_group["${each.key}"].annotations, null),
        try(var.rule_groups.rule_group["${each.key}"].rule["${rule_item.value.rule.title}"].annotations, null)
      )
      labels = merge(
        try(rule_item.value.rule.labels, null),
        try(var.labels, null),
        try(var.rule_groups.labels, null),
        try(var.rule_groups.rule_group["${each.key}"].labels, null),
        try(var.rule_groups.rule_group["${each.key}"].rule["${rule_item.value.rule.title}"].labels, null),
        {
          "datasource" = rule_item.value.ds_name
        }
      )
      is_paused = (
        try(rule_item.value.rule.pause,
          try(var.rule_groups.rule_group["${each.key}"].rule["${rule_item.value.rule.title}"].pause,
            try(var.rule_groups.rule_group["${each.key}"].pause,
              try(var.rule_groups.pause, false)
            )
          )
        )
      )

      dynamic "notification_settings" {
        for_each = (
          try([var.rule_groups.rule_group["${each.key}"].rule["${rule_item.value.rule.title}"].notification_settings],
            try([var.rule_groups.rule_group["${each.key}"].notification_settings],
              try([var.rule_groups.notification_settings],
                try([rule_item.value.rule.notification_settings], [])
              )
            )
          )
        )
        iterator = notification_settings
        content {
          contact_point   = notification_settings.value.receiver
          group_by        = try(notification_settings.value.group_by, null)
          group_interval  = try(notification_settings.value.group_interval, null)
          group_wait      = try(notification_settings.value.group_wait, null)
          mute_timings    = try(notification_settings.value.mute_timings, null)
          repeat_interval = try(notification_settings.value.repeat_interval, null)
        }
      }

      dynamic "data" {
        for_each = rule_item.value.rule.data
        iterator = data
        content {
          ref_id = data.value.refId
          datasource_uid = (
            can(data.value.model.type)
            ? local.expression_datasource_uid
            : try(local.datasource_uids[rule_item.value.ds_name], null)
          )
          model = jsonencode(merge(data.value.model, {
            refId = data.value.refId,
          }))
          relative_time_range {
            from = try(data.value.relativeTimeRange.from, 0)
            to   = try(data.value.relativeTimeRange.to, 0)
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [rule]
  }
}
