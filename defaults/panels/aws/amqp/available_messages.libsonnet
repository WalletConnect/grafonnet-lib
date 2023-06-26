local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

{
  title:: 'Available Messages (Queue Depth)',
  panel(
    datasource,
    broker,
    title           = $.title,
  ):: grafana.panels.timeseries(
    title           = title,
    datasource      = datasource,
  )

  .configure(
    defaults.configuration.timeseries_resource
  )

  .addTarget(grafana.targets.cloudwatch(
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.AmazonMQ,
    metricName  = grafana.target.cloudwatch.metrics.amqp.TotalMessageCount,
    dimensions  = {
      Broker: broker,
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Maximum,
  ))
}
