local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

{
  title:: 'Network Throughput',
  panel(
    datasource,
    cluster_id,
    title         = $.title,
    statistic     = grafana.target.cloudwatch.statistics.Maximum,
  ):: grafana.panels.timeseries(
    title         = title,
    datasource    = datasource,
  )
  .configure(defaults.configuration.timeseries)

  .addTarget(grafana.targets.cloudwatch(
    alias         = 'Throughput',
    datasource    = datasource,
    namespace     = grafana.target.cloudwatch.namespace.DocDB,
    metricName    = grafana.target.cloudwatch.metrics.docdb.NetworkThroughput,
    dimensions    = {
      DBClusterIdentifier: cluster_id
    },
    matchExact    = true,
    statistic     = statistic,
  ))
}
