local grafana         = import '../grafana.libsonnet';
local strings         = import '../utils/strings.libsonnet';
local defaults        = import '../defaults/values.libsonnet';

{
  timeseries:: grafana.panels.timeseries().createConfiguration(
    scaleDistribution = {
      type : 'linear'
    },
    legend  = grafana.common.legend(),
    tooltip = grafana.common.tooltip(),
  ),

  timeseries_resource:: grafana.panels.timeseries().createConfiguration(
    scaleDistribution = {
      type: 'linear'
    },
    legend  = grafana.common.legend(),
    tooltip = grafana.common.tooltip(),
  )
  .withThresholdStyle(grafana.fieldConfig.thresholdStyle.area)
  .addThreshold({
    color : defaults.colors.warn,
    value : defaults.resource.thresholds.warning,
  })
  .addThreshold({
    color : defaults.colors.critical,
    value : defaults.resource.thresholds.critical,
  })
  .withUnit('percent')
  .withSoftLimit(
    axisSoftMin = 0,
    axisSoftMax = defaults.resource.thresholds.warning,
  ),

  docdb_available_memory(
    max_memory    = defaults.available_memory.capacity,
    mem_threshold = defaults.available_memory.threshold,
    refid         = defaults.refid.mem,
  ):: grafana.panels.timeseries().createConfiguration(
    scaleDistribution = {
      type : 'linear'
    },
    legend  = grafana.common.legend(),
    tooltip = grafana.common.tooltip(),
  )
  .withThresholdStyle(grafana.fieldConfig.thresholdStyle.area)
  .setThresholds(
    baseColor = defaults.colors.critical,
    steps = [
      { value: mem_threshold, color: defaults.colors.ok },
    ]
  )
  .withUnit('decbytes')
  .addOverride(grafana.override.new(
    name = '%s_Min' % refid,
    properties = [{
      id: 'color',
      value: {
        mode: 'fixed',
        fixedColor: defaults.colors.memory_alt,
      }
    }],
  ))
  .addOverride(grafana.override.new(
    name = '%s_Avg' % refid,
    properties = [{
      id: 'color',
      value: {
        mode: 'fixed',
        fixedColor: defaults.colors.memory,
      }
    }],
  ))
  .withSoftLimit(
    axisSoftMin = 0,
    axisSoftMax = max_memory,
  ),
}
