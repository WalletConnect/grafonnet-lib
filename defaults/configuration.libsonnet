local grafana         = import '../grafana.libsonnet';
local strings         = import '../utils/strings.libsonnet';
local values          = import '../defaults/values.libsonnet';

{
  timeseries:: grafana.panel.timeseries.configuration.new(
    scaleDistribution = {
      type : 'linear'
    },
    legend  = grafana.common.legend(),
    tooltip = grafana.common.tooltip(),
  ),


  timeseries_resource:: grafana.panel.timeseries.configuration.new(
    scaleDistribution = {
      type: 'linear'
    },
    legend  = grafana.common.legend(),
    tooltip = grafana.common.tooltip(),
  )
  .withThresholdStyle(grafana.common.graphTresholdsStyle.Area)
  .addThreshold(grafana.threshold.new(
    value = values.resource.thresholds.warning,
    color = values.colors.warn,
  ))
  .addThreshold(grafana.threshold.new(
    value = values.resource.thresholds.critical,
    color = values.colors.critical,
  ))
  .withUnit(grafana.common.units.Percent)
  .withSoftLimit(
    axisSoftMin = 0,
    axisSoftMax = values.resource.thresholds.warning,
  ),
}
