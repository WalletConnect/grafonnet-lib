local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

local refid_CPU_Max   = '%s_Max' % defaults.values.refid.cpu;
local refid_CPU_Avg   = '%s_Avg' % defaults.values.refid.cpu;

{
  title:: 'ECS CPU Utilization',
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
    refid           = defaults.values.alerts.cpu.refid,
    limit           = defaults.values.alerts.cpu.limit,
    reducer         = defaults.values.alerts.cpu.reducer,

  ):: grafana.panels.timeseries(
    title           = title,
    datasource      = datasource,
  )

  .configure(
    defaults.configuration.timeseries_resource
  )

  .setAlert(
    environment,
    defaults.alerts.cpu(
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
    )
  )

  .addTarget(grafana.targets.cloudwatch(
    alias         = 'CPU (Max)',
    datasource    = datasource,
    namespace     = grafana.target.cloudwatch.namespace.ECS,
    metricName    = grafana.target.cloudwatch.metrics.ecs.CPUUtilization,
    dimensions    = {
      ServiceName: service_name,
      [if cluster_name != null then 'ClusterName']: cluster_name,
    },
    matchExact    = matchExact,
    statistic     = grafana.target.cloudwatch.statistics.Maximum,
    refId         = refid_CPU_Max,
  ))
  .addTarget(grafana.targets.cloudwatch(
    alias         = 'CPU (Avg)',
    datasource    = datasource,
    namespace     = grafana.target.cloudwatch.namespace.ECS,
    metricName    = grafana.target.cloudwatch.metrics.ecs.CPUUtilization,
    dimensions    = {
      ServiceName: service_name,
      [if cluster_name != null then 'ClusterName']: cluster_name,
    },
    matchExact    = matchExact,
    statistic     = grafana.target.cloudwatch.statistics.Average,
    refId         = refid_CPU_Avg,
  ))
}
