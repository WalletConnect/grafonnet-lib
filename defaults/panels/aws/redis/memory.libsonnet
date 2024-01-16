local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

local refid_Mem_Max   = '%s_Max' % defaults.values.refid.mem;

{
  title:: 'Redis Memory',
  panel(
    namespace,
    environment,
    notifications,
    datasource,
    cluster_id,
    title         = $.title,
    priority      = null,
  ):: grafana.panels.timeseries(
    title       = title,
    datasource  = datasource,
  )

  .configure(defaults.configuration.timeseries_resource)

  .setAlert(
    environment,
    defaults.alerts.memory(
      namespace     = namespace,
      env           = environment,
      title         = "%s - %s"   % [environment, title],
      notifications = notifications,
      priority      = priority,
      reducer       = grafana.alertCondition.reducers.Max,
    )
  )

  .addTarget(grafana.targets.cloudwatch(
    alias       = 'Memory (Max)',
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.ElastiCache,
    metricName  = grafana.target.cloudwatch.metrics.elasticache.DatabaseMemoryUsagePercentage,
    dimensions  = {
      CacheClusterId : cluster_id
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Maximum,
    refId       = refid_Mem_Max,
  ))
}
