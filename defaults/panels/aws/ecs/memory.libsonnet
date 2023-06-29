local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

local refid_Mem_Max   = '%s_Max' % defaults.values.refid.mem;
local refid_Mem_Avg   = '%s_Avg' % defaults.values.refid.mem;

{
  title:: 'ECS Memory Utilization',
  panel(
    datasource,
    namespace,
    environment,
    notifications,
    service_name,
    cluster_name    = null,
    matchExact      = true,
    title           = $.title,
    priority        = null,
    period          = defaults.values.alerts.period,
    frequency       = defaults.values.alerts.frequency,
    timeStart       = defaults.values.alerts.timeStart,
    refid           = defaults.values.alerts.mem.refid,
    limit           = defaults.values.alerts.mem.limit,
    reducer         = defaults.values.alerts.mem.reducer,

  ):: grafana.panels.timeseries(
    title           = title,
    datasource      = datasource,
  )

  .configure(
    defaults.configuration.timeseries_resource
  )

  .setAlert(defaults.alerts.memory(
    namespace     = namespace,
    env           = environment,
    title         = title,
    notifications = notifications,
    priority      = priority,
    timeStart     = timeStart,
    period        = period,
    frequency     = frequency,
    refid         = refid,
    limit         = limit,
    reducer       = reducer,
  ))

  .addTarget(grafana.targets.cloudwatch(
    alias         = 'Memory (Max)',
    datasource    = datasource,
    namespace     = grafana.target.cloudwatch.namespace.ECS,
    metricName    = grafana.target.cloudwatch.metrics.ecs.MemoryUtilization,
    dimensions    = {
      ServiceName: service_name
      [if cluster_name != null then 'ClusterName']: cluster_name,
    },
    matchExact    = matchExact,
    statistic     = grafana.target.cloudwatch.statistics.Maximum,
    refId         = refid_Mem_Max,
  ))
  .addTarget(grafana.targets.cloudwatch(
    alias         = 'Memory (Avg)',
    datasource    = datasource,
    namespace     = grafana.target.cloudwatch.namespace.ECS,
    metricName    = grafana.target.cloudwatch.metrics.ecs.MemoryUtilization,
    dimensions    = {
      ServiceName: service_name
      [if cluster_name != null then 'ClusterName']: cluster_name,
    },
    matchExact    = matchExact,
    statistic     = grafana.target.cloudwatch.statistics.Average,
    refId         = refid_Mem_Avg,
  ))
}
