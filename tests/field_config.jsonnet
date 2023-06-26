local grafana = import '../grafana.libsonnet';

{
  // new:                grafana.fieldConfig.new(),

  withThresholds: {
    no_steps:         grafana.fieldConfig.new().withThresholds('blue'),
    one_steps:        grafana.fieldConfig.new().withThresholds('blue', [{ value: 50, color: 'yellow' }]),
  },

  withThresholdStyle: grafana.fieldConfig.new().withThresholdStyle(grafana.fieldConfig.thresholdStyle.Area),

  addThreshold:       grafana.fieldConfig.new().addThreshold(grafana.threshold.new(50, 'red')),
  addThresholds:      grafana.fieldConfig.new().addThresholds([
    grafana.threshold.new(value = 50, color = 'orange'),
    grafana.threshold.new(value = 90, color = 'red'),
  ]),

  addOverride:        grafana.fieldConfig.new().addOverride(grafana.override.newColorOverride('A', 'red')),
  addOverrides:       grafana.fieldConfig.new().addOverrides([
    grafana.override.newColorOverride('A', 'red'),
    grafana.override.newColorOverride('B', 'blue'),
  ]),

  withColor: {
    fixed:            grafana.fieldConfig.new().withColor(grafana.fieldConfig.colorMode.Fixed, 'red'),
    mode:             grafana.fieldConfig.new().withColor(grafana.fieldConfig.colorMode.Thresholds)
  },

  withSoftLimit: {
    default:          grafana.fieldConfig.new().withSoftLimit(),
    one_steps:        grafana.fieldConfig.new().withSoftLimit(50),
    two_steps:        grafana.fieldConfig.new().withSoftLimit(50, 90),
  },

  withUnit:       grafana.fieldConfig.new().withUnit(grafana.fieldConfig.units.Percent),
}
