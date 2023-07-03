local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

local refid_Mem_Min   = '%s_Min' % defaults.values.refid.mem;
local refid_Mem_Avg   = '%s_Avg' % defaults.values.refid.mem;

{
  title:: 'Available Memory',
  panel(
    datasource,
    namespace,
    environment,
    notifications,
    cluster_id,
    title         = $.title,
    priority      = defaults.values.priorities.Moderate,
    mem_threshold = defaults.values.available_memory.threshold,
    max_memory    = defaults.values.available_memory.capacity,
  ):: grafana.panels.timeseries(
    title         = title,
    datasource    = datasource,
  )

  .configure(
    defaults.configuration.timeseries
    .withThresholdStyle(grafana.common.graphTresholdsStyle.Area)
    .withThresholds(
      baseColor = defaults.values.colors.critical,
      steps = [
        { value: mem_threshold, color: defaults.values.colors.ok },
      ]
    )
    .withUnit(grafana.common.units.Kibibytes)
    .addOverride(grafana.override.newColorOverride(refid_Mem_Min, defaults.values.colors.memory_alt))
    .addOverride(grafana.override.newColorOverride(refid_Mem_Avg, defaults.values.colors.memory))
    .withSoftLimit(
      axisSoftMin = 0,
      axisSoftMax = max_memory,
    )
  )
  .XaddPanelThreshold(
    op            = grafana.alertCondition.evaluators.Below,
    value         = mem_threshold,
  )

  .setAlert(
    grafana.alert.new(
      namespace     = namespace,
      name          = '%s - DocumentDB - Available Memory alert'              % environment,
      message       = '%s - DocumentDB - Available Memory is low (under %s)'  % [environment, grafana.utils.strings.sizeof_fmt(mem_threshold)],
      notifications = notifications,
      conditions    = [
        grafana.alertCondition.new(
          evaluatorParams = [ mem_threshold ],
          evaluatorType   = grafana.alertCondition.evaluators.Below,
          operatorType    = grafana.alertCondition.operators.And,
          queryRefId      = refid_Mem_Avg,
          reducerType     = grafana.alertCondition.reducers.Avg,
        ),
      ],
    )
    .withPriority(priority)
  )

  .addTarget(grafana.targets.cloudwatch(
    alias       = 'Available Memory (Min)',
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.DocDB,
    metricName  = grafana.target.cloudwatch.metrics.docdb.FreeableMemory,
    dimensions  = {
      DBClusterIdentifier: cluster_id
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Minimum,
    refId       = refid_Mem_Min,
  ))
  .addTarget(grafana.targets.cloudwatch(
    alias       = 'Available Memory (Avg)',
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.DocDB,
    metricName  = grafana.target.cloudwatch.metrics.docdb.FreeableMemory,
    dimensions  = {
      DBClusterIdentifier: cluster_id
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Average,
    refId       = refid_Mem_Avg,
  ))
}
