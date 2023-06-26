local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

local refid_CPU_Max   = '%s_Max' % defaults.values.refid.cpu;
local refid_CPU_Avg   = '%s_Avg' % defaults.values.refid.cpu;
local refid_Mem_Max   = '%s_Max' % defaults.values.refid.mem;
local refid_Mem_Avg   = '%s_Avg' % defaults.values.refid.mem;

{
  title:: 'ECS CPU/Memory',
  panel(
    datasource,
    namespace,
    environment,
    notifications,
    service_name,
    title           = $.title,
    priority        = null,
    period          = defaults.values.alerts.period,
    frequency       = defaults.values.alerts.frequency,
    timeStart       = defaults.values.alerts.timeStart,
    cpu_refid       = defaults.values.alerts.cpu.refid,
    cpu_limit       = defaults.values.alerts.cpu.limit,
    cpu_reducer     = defaults.values.alerts.cpu.reducer,
    memory_refid    = defaults.values.alerts.mem.refid,
    memory_limit    = defaults.values.alerts.mem.limit,
    memory_reducer  = defaults.values.alerts.mem.reducer,

  ):: grafana.panels.timeseries(
    title           = title,
    datasource      = datasource,
  )

  .configure(
    defaults.configuration.timeseries_resource
  )

  .setAlert(defaults.alerts.cpu_mem(
    namespace     = namespace,
    env           = environment,
    title         = title,
    notifications = notifications,
    priority      = priority,
    period        = period,
    frequency     = frequency,
    cpu           = {
      refid       : cpu_refid,
      limit       : cpu_limit,
      reducer     : cpu_reducer,
      timeStart   : timeStart,
    },
    memory        = {
      refid       : memory_refid,
      limit       : memory_limit,
      reducer     : memory_reducer,
      timeStart   : timeStart,
    },
  ))

  .addTarget(grafana.targets.cloudwatch(
    alias         = 'CPU (Max)',
    datasource    = datasource,
    namespace     = grafana.target.cloudwatch.namespace.ECS,
    metricName    = grafana.target.cloudwatch.metrics.ecs.CPUUtilization,
    dimensions    = {
      ServiceName: service_name
    },
    statistic     = grafana.target.cloudwatch.statistics.Maximum,
    refId         = refid_CPU_Max,
  ))
  .addTarget(grafana.targets.cloudwatch(
    alias         = 'CPU (Avg)',
    datasource    = datasource,
    namespace     = grafana.target.cloudwatch.namespace.ECS,
    metricName    = grafana.target.cloudwatch.metrics.ecs.CPUUtilization,
    dimensions    = {
      ServiceName: service_name
    },
    statistic     = grafana.target.cloudwatch.statistics.Average,
    refId         = refid_CPU_Avg,
  ))

  .addTarget(grafana.targets.cloudwatch(
    alias         = 'Memory (Max)',
    datasource    = datasource,
    namespace     = grafana.target.cloudwatch.namespace.ECS,
    metricName    = grafana.target.cloudwatch.metrics.ecs.MemoryUtilization,
    dimensions    = {
      ServiceName: service_name
    },
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
    },
    statistic     = grafana.target.cloudwatch.statistics.Average,
    refId         = refid_Mem_Avg,
  ))
}
