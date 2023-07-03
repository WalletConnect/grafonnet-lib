local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

{
  title:: 'Buffer Cache Hit Ratio',
  panel(
    datasource,
    cluster_id,
    title         = $.title,
    statistic     = grafana.target.cloudwatch.statistics.Average,
  ):: grafana.panels.timeseries(
    title         = title,
    description   = 'See https://docs.aws.amazon.com/documentdb/latest/developerguide/best_practices.html',
    datasource    = datasource,
  )
  .configure(
    defaults.configuration.timeseries
    .withUnit(grafana.common.units.Percent)
    .withSoftLimit(
      axisSoftMin = 90,
      axisSoftMax = 100,
    )
  )
  .addTarget(grafana.targets.cloudwatch(
    alias         = 'Cache Hits',
    datasource    = datasource,
    namespace     = grafana.target.cloudwatch.namespace.DocDB,
    metricName    = grafana.target.cloudwatch.metrics.docdb.BufferCacheHitRatio,
    dimensions    = {
      DBClusterIdentifier: cluster_id
    },
    matchExact    = true,
    statistic     = statistic,
  ))
}
