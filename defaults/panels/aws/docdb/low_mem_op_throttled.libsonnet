local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

local refid_Ops_Max   = 'Ops_Max';

{
  title:: 'LowMem Num Operations Throttled',
  panel(
    datasource,
    namespace,
    environment,
    notifications,
    cluster_id,
    title         = $.title,
    priority      = defaults.values.priorities.Moderate,
    statistic     = grafana.target.cloudwatch.statistics.Maximum,
    ops_threshold = 2
  ):: grafana.panels.timeseries(
    title         = title,
    datasource    = datasource,
  )
  .configure(
    defaults.configuration.timeseries
    .withSoftLimit(
        axisSoftMin = 0,
        axisSoftMax = 10,
    )
    .addOverride(grafana.override.newColorOverride(refid_Ops_Max, defaults.values.colors.critical))
    .withThresholdStyle('area')
    .addThreshold(grafana.threshold.new(
        value = ops_threshold,
        color = defaults.values.colors.critical,
    ))
  )

  .setAlert(
    environment,
    grafana.alert.new(
      namespace     = namespace,
      name          = "%s - DocumentDB - LowMem Num Operations Throttled Alert" % environment,
      message       = "%s - DocumentDB - LowMem Num Operations Throttled"       % environment,
      notifications = notifications,
      conditions  = [
        grafana.alertCondition.new(
          evaluatorParams = [ ops_threshold ],
          evaluatorType   = grafana.alertCondition.evaluators.Above,
          operatorType    = grafana.alertCondition.operators.And,
          queryRefId      = refid_Ops_Max,
          reducerType     = grafana.alertCondition.reducers.Max,
        ),
      ]
    )
    .withPriority(priority)
  )

  .addTarget(grafana.targets.cloudwatch(
    alias         = 'Operations',
    datasource    = datasource,
    namespace     = grafana.target.cloudwatch.namespace.DocDB,
    metricName    = grafana.target.cloudwatch.metrics.docdb.LowMemNumOperationsThrottled,
    dimensions    = {
      DBClusterIdentifier: cluster_id
    },
    matchExact    = true,
    statistic     = statistic,
    refId         = refid_Ops_Max,
  ))
}
