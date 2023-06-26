local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

{
  title:: 'Broker Heap Usage',
  panel(
    datasource,
    broker,
    title           = $.title,
  ):: grafana.panels.timeseries(
    title           = title,
    description     = 'The percentage of the ActiveMQ JVM memory limit that the broker currently uses.',
    datasource      = datasource,
  )

  .configure(
    defaults.configuration.timeseries_resource
  )

  .addTarget(grafana.targets.cloudwatch(
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.AmazonMQ,
    metricName  = grafana.target.cloudwatch.metrics.amqp.HeapUsage,
    dimensions  = {
      Broker: broker
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Average,
  ))
}
