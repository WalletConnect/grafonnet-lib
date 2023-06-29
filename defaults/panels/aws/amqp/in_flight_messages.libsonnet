local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

{
  title:: 'In-Flight Messages',
  panel(
    datasource,
    broker,
    queue,
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
    metricName  = grafana.target.cloudwatch.metrics.amazonmq.InFlightCount,
    dimensions  = {
      Broker: broker,
      Queue:  queue,
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Maximum,
  ))
}
