local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

{
  title:: 'Used Volume',
  panel(
    datasource,
    cluster_id,
    title         = $.title,
    statistic     = grafana.target.cloudwatch.statistics.Maximum,
  ):: grafana.panels.timeseries(
    title         = title,
    description   = 'Max is 64TB',
    datasource    = datasource,
  )

  .configure(
    defaults.configuration.timeseries
    .withUnit(grafana.common.units.DecBytes)
    .addThreshold(grafana.threshold.new(
      value = grafana.utils.units.size_dec(TB = 40),  // 40TB, Max is 64TB.
      color = defaults.values.colors.critical,
    ))
    .withSpanNulls(true)
  )

  .addTarget(grafana.targets.cloudwatch(
    datasource    = datasource,
    namespace     = grafana.target.cloudwatch.namespace.DocDB,
    metricName    = grafana.target.cloudwatch.metrics.docdb.VolumeBytesUsed,
    dimensions    = {
      DBClusterIdentifier: cluster_id
    },
    statistic     = statistic,
  ))
}
