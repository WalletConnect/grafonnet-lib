local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

{
  title:: 'Database Connections',
  panel(
    datasource,
    cluster_id,
    title         = $.title,
    statistic     = grafana.target.cloudwatch.statistics.Average,
  ):: grafana.panels.timeseries(
    title         = title,
    description   = 'The number of connections open on an instance taken at a one-minute frequency.',
    datasource    = datasource,
  )
  .configure(
    defaults.configuration.timeseries
    .withUnit(grafana.fieldConfig.units.CountsPerMinute)
  )
  .addTarget(grafana.targets.cloudwatch(
    alias         = 'Connections',
    datasource    = datasource,
    namespace     = grafana.target.cloudwatch.namespace.DocDB,
    metricName    = grafana.target.cloudwatch.metrics.docdb.DatabaseConnections,
    dimensions    = {
      DBClusterIdentifier: cluster_id
    },
    matchExact    = true,
    statistic     = statistic,
  ))
}
