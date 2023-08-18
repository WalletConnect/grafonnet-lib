local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

local refid_CPU_Max   = '%s_Max' % defaults.values.refid.cpu;
local refid_CPU_Avg   = '%s_Avg' % defaults.values.refid.cpu;

{
  title:: 'Broker CPU Utilization',
  panel(
    datasource,
    namespace,
    environment,
    notifications,
    broker,
    title           = $.title,
    priority        = null,
    reducer         = defaults.values.alerts.cpu.reducer,
    limit           = defaults.values.alerts.cpu.limit,
  ):: grafana.panels.timeseries(
    title           = title,
    description     = 'The percentage of allocated Amazon EC2 compute units that the broker currently uses.',
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
      limit         = limit,
      reducer       = reducer,
    )
  )

  .addTarget(grafana.targets.cloudwatch(
    alias       = "CPU (Max)",
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.AmazonMQ,
    metricName  = grafana.target.cloudwatch.metrics.amazonmq.CpuUtilization,
    dimensions  = {
      Broker: broker,
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Maximum,
    refId       = refid_CPU_Max,
  ))
  .addTarget(grafana.targets.cloudwatch(
    alias       = "CPU (Avg)",
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.AmazonMQ,
    metricName  = grafana.target.cloudwatch.metrics.amazonmq.CpuUtilization,
    dimensions  = {
      Broker: broker,
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Average,
    refId       = refid_CPU_Avg,
  ))
}
