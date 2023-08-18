local grafana         = import '../../../../grafana.libsonnet';
local defaults        = import '../../../../defaults.libsonnet';

local refids = {
  cpu_writer_max: '%s_Writer_Max' % defaults.values.refid.cpu,
  cpu_writer_avg: '%s_Writer_Avg' % defaults.values.refid.cpu,
  cpu_reader_max: '%s_Reader_Max' % defaults.values.refid.cpu,
  cpu_reader_avg: '%s_Reader_Avg' % defaults.values.refid.cpu,
};
local colors = {
  cpu_writer_max: 'dark-yellow',
  cpu_writer_avg: 'yellow',
  cpu_reader_max: 'dark-blue',
  cpu_reader_avg: 'blue',
};

{
  title:: 'CPU Utilization',
  panel(
    datasource,
    namespace,
    environment,
    notifications,
    cluster_id,
    title         = $.title,
  ):: grafana.panels.timeseries(
    title         = title,
    datasource    = datasource,
  )
  .configure(
    defaults.configuration.timeseries_resource
    .addOverride(grafana.override.newColorOverride(refids.cpu_writer_max, colors.cpu_writer_max))
    .addOverride(grafana.override.newColorOverride(refids.cpu_writer_avg, colors.cpu_writer_avg))
    .addOverride(grafana.override.newColorOverride(refids.cpu_reader_max, colors.cpu_reader_max))
    .addOverride(grafana.override.newColorOverride(refids.cpu_reader_avg, colors.cpu_reader_avg))
  )
  .setAlert(
    environment,
    grafana.alert.new(
      namespace     = namespace,
      name          = "%s - DocumentDB - CPU alert" % environment,
      message       = "%s - DocumentDB - CPU alert" % environment,
      notifications = notifications,
      conditions  = [
        grafana.alertCondition.new(
            evaluatorParams = [ defaults.values.resource.thresholds.critical ],
            evaluatorType   = grafana.alertCondition.evaluators.Above,
            operatorType    = grafana.alertCondition.operators.Or,
            queryRefId      = refids.cpu_writer_max,
            reducerType     = grafana.alertCondition.reducers.Avg,
        ),
        grafana.alertCondition.new(
            evaluatorParams = [ defaults.values.resource.thresholds.critical ],
            evaluatorType   = grafana.alertCondition.evaluators.Above,
            operatorType    = grafana.alertCondition.operators.Or,
            queryRefId      = refids.cpu_reader_max,
            reducerType     = grafana.alertCondition.reducers.Avg,
        ),
      ]
    )
  )
  .addTarget(grafana.targets.cloudwatch(
    alias       = 'CPU Writer (Max)',
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.DocDB,
    metricName  = grafana.target.cloudwatch.metrics.docdb.CPUUtilization,
    dimensions  = {
      DBClusterIdentifier:  cluster_id,
      Role:                 'WRITER'
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Maximum,
    refId       = refids.cpu_writer_max,
  ))
  .addTarget(grafana.targets.cloudwatch(
    alias       = 'CPU Writer (Avg)',
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.DocDB,
    metricName  = grafana.target.cloudwatch.metrics.docdb.CPUUtilization,
    dimensions  = {
      DBClusterIdentifier:  cluster_id,
      Role:                 'WRITER'
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Average,
    refId       = refids.cpu_writer_avg,
  ))
  .addTarget(grafana.targets.cloudwatch(
    alias       = 'CPU Reader (Max)',
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.DocDB,
    metricName  = grafana.target.cloudwatch.metrics.docdb.CPUUtilization,
    dimensions  = {
      DBClusterIdentifier:  cluster_id,
      Role:                 'READER'
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Maximum,
    refId       = refids.cpu_reader_max,
  ))
  .addTarget(grafana.targets.cloudwatch(
    alias       = 'CPU Reader (Avg)',
    datasource  = datasource,
    namespace   = grafana.target.cloudwatch.namespace.DocDB,
    metricName  = grafana.target.cloudwatch.metrics.docdb.CPUUtilization,
    dimensions  = {
      DBClusterIdentifier:  cluster_id,
      Role:                 'READER'
    },
    matchExact  = true,
    statistic   = grafana.target.cloudwatch.statistics.Average,
    refId       = refids.cpu_reader_avg,
  ))
}
