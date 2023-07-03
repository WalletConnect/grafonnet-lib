local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

{
  title:: 'Write Latency',
  panel(
    datasource,
    cluster_id,
    title         = $.title,
    statistic     = grafana.target.cloudwatch.statistics.Average,
  ):: grafana.panels.timeseries(
    title         = title,
    datasource    = datasource,
  )

  .configure(
    defaults.configuration.timeseries
      .addThreshold(grafana.threshold.new(
        value = 0.015,
        color = defaults.values.colors.warn
      ))
      .addThreshold(grafana.threshold.new(
        value = 0.5,
        color = defaults.values.colors.critical
      ))
      .withThresholdStyle(grafana.common.graphTresholdsStyle.Area)
  )

  .addTarget(grafana.targets.cloudwatch(
    alias       = 'Write Latency',
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.DocDB,
    metricName  = grafana.target.cloudwatch.metrics.docdb.WriteLatency,
    dimensions  = {
      DBClusterIdentifier: cluster_id
    },
    matchExact  = true,
    statistic   = statistic,
  ))
}
