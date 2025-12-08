{
  /**
   * DEPRECATED: Legacy Panel-Based Alerts
   *
   * This module is deprecated as of Grafana 10+.
   * Panel-based alerts have been replaced by Unified Alerting.
   *
   * For new alert rules, use alertRule.libsonnet instead.
   * See alerts.jsonnet for examples of the new format.
   *
   * This file is kept for backwards compatibility reference only.
   *
   * @deprecated Use alertRule.libsonnet for Grafana 10+ compatible alerts
   */
  new(
    namespace,
    name,
    alertRuleTags       = {},
    conditions          = [],
    executionErrorState = "alerting",
    period              = "5m",
    frequency           = "1m",
    handler             = 1,
    message,
    noDataState         = "alerting",
    notifications        = []

  ):: {
    name:                 "%s - %s" % [namespace, name],
    message:              "%s - %s" % [namespace, message],
    alertRuleTags:        alertRuleTags,
    conditions:           conditions,
    executionErrorState:  executionErrorState,
    'for':                period,
    frequency:            frequency,
    handler:              handler,
    noDataState:          noDataState,
    notifications:        notifications,

    withCondition(condition):: self + {
      conditions+: [condition]
    },
    withConditions(conditions):: self + {
      conditions+: conditions
    },

    withPriority(priority):: self + {
      alertRuleTags+: {
        'og_priority': priority
      }
    },
  },
}
