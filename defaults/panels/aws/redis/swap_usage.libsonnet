local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

local refid_FreeableMemory  = 'FreeableMemory';
local refid_SwapUsage       = 'SwapUsage';
local refid_Pressure        = 'Pressure';

{
  title:: 'Redis Swap Usage',
  panel(
    datasource,
    namespace,
    environment,
    notifications,
    cluster_id,
    title         = $.title,
    priority      = null,
  ):: grafana.panels.timeseries(
    title       = title,
    datasource  = datasource,
  )

  .configure(defaults.configuration.timeseries)

  .setAlert(
    environment,
    grafana.alert.new(
      namespace     = namespace,
      name          = "%s - %s - Swap Usage alert"    % [grafana.utils.strings.capitalize(environment), title],
      message       = '%s - %s - swap usage is high'  % [grafana.utils.strings.capitalize(environment), title],
      notifications = notifications,
      conditions    = [
        grafana.alertCondition.new(
          evaluatorParams = [ grafana.utils.units.size_bin(MiB = 100) ],
          evaluatorType   = grafana.alertCondition.evaluators.Below,
          operatorType    = grafana.alertCondition.operators.Or,
          queryRefId      = refid_FreeableMemory,
          reducerType     = grafana.alertCondition.reducers.Avg,
        ),
        grafana.alertCondition.new(
          evaluatorParams = [ 0 ],
          evaluatorType   = grafana.alertCondition.evaluators.Below,
          operatorType    = grafana.alertCondition.operators.Or,
          queryRefId      = refid_Pressure,
          reducerType     = grafana.alertCondition.reducers.Avg,
        ),
      ],
    )
  )

  .addTarget(grafana.targets.cloudwatch(
    alias       = 'Freeable Memory',
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.ElastiCache,
    metricName  = grafana.target.cloudwatch.metrics.elasticache.FreeableMemory,
    dimensions  = {
      CacheClusterId : cluster_id
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Minimum,
    refId       = refid_FreeableMemory,
  ))
  .addTarget(grafana.targets.cloudwatch(
    alias       = 'Swap Usage',
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.ElastiCache,
    metricName  = grafana.target.cloudwatch.metrics.elasticache.SwapUsage,
    dimensions  = {
      CacheClusterId : cluster_id
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Minimum,
    refId       = refid_SwapUsage,
  ))
  .addTarget(grafana.targets.math(
    expr        = '$%s - $%s' % [refid_FreeableMemory, refid_SwapUsage],
    refId       = refid_Pressure,
    hide        = true,
  ))
}
