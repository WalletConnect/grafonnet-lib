local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

{
  title:: 'Store Usage',
  panel(
    datasource,
    broker,
    title           = $.title,
  ):: grafana.panels.timeseries(
    title           = title,
    description     = 'The percent used by the storage limit. If this reaches 100, the broker will refuse messages.',
    datasource      = datasource,
  )

  .configure(
    defaults.configuration.timeseries
    .withThresholds(
      baseColor = defaults.values.colors.ok,
      steps = [
        { value: 50, color: defaults.values.colors.critical },
      ]
    )
    .withUnit('percent')
    .withSoftLimit(
      axisSoftMin = 0,
      axisSoftMax = 100,
    )
  )

  .addTarget(grafana.targets.cloudwatch(
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.AmazonMQ,
    metricName  = grafana.target.cloudwatch.metrics.amqp.StorePercentUsage,
    dimensions  = {
      Broker: broker,
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Average,
  ))
}
