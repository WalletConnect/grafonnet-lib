local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

local refid_HostCPU_Max   = '%s_Max' % defaults.values.refid.cpu;
local refid_EngineCPU_Max = '%s_Engine_Max' % defaults.values.refid.mem;

{
  title:: 'Redis CPU',
  panel(
    datasource,
    namespace,
    environment,
    notifications,
    cluster_id,
    title         = $.title,
    priority      = null,
  ):: grafana.panels.timeseries(
    title         = title,
    datasource    = datasource,
  )

  .configure(defaults.configuration.timeseries_resource)

  .setAlert(defaults.alerts.cpu(
      namespace     = namespace,
      env           = environment,
      title         = title,
      notifications = notifications,
      priority      = priority,
  ))

  .addTarget(grafana.targets.cloudwatch(
    alias       = 'Host CPU',
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.ElastiCache,
    metricName  = grafana.target.cloudwatch.metrics.elasticache.CPUUtilization,
    dimensions  = {
      CacheClusterId : cluster_id
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Maximum,
    refId       = refid_HostCPU_Max,
  ))
  .addTarget(grafana.targets.cloudwatch(
    alias       = 'Engine CPU',
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.ElastiCache,
    metricName  = grafana.target.cloudwatch.metrics.elasticache.EngineCPUUtilization,
    dimensions  = {
      CacheClusterId : cluster_id
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Maximum,
    refId       = refid_EngineCPU_Max,
  ))
}
