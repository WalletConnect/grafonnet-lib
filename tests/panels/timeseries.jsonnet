local grafana = import '../../grafana.libsonnet';

{
  new: grafana.panel.timeseries.new(
    title       = 'title',
    description = 'description',
    datasource  = 'datasource',
  ),

  configuration: grafana.panel.timeseries.configuration.new(),

  withThresholds: {
    no_steps:         grafana.panel.timeseries.configuration.new().withThresholds('blue'),
    one_steps:        grafana.panel.timeseries.configuration.new().withThresholds('blue', [{ value: 50, color: 'yellow' }]),
  },

  withThresholdStyle: grafana.panel.timeseries.configuration.new().withThresholdStyle(grafana.fieldConfig.thresholdStyle.Area),

  addThreshold:       grafana.panel.timeseries.configuration.new().addThreshold(grafana.threshold.new(50, 'red')),
  addThresholds:      grafana.panel.timeseries.configuration.new().addThresholds([
    grafana.threshold.new(value = 50, color = 'orange'),
    grafana.threshold.new(value = 90, color = 'red'),
  ]),

  addOverride:        grafana.panel.timeseries.configuration.new().addOverride(grafana.override.newColorOverride('A', 'red')),
  addOverrides:       grafana.panel.timeseries.configuration.new().addOverrides([
    grafana.override.newColorOverride('A', 'red'),
    grafana.override.newColorOverride('B', 'blue'),
  ]),

  withColor: {
    fixed:            grafana.panel.timeseries.configuration.new().withColor(grafana.fieldConfig.colorMode.Fixed, 'red'),
    mode:             grafana.panel.timeseries.configuration.new().withColor(grafana.fieldConfig.colorMode.Thresholds)
  },

  withSoftLimit: {
    default:          grafana.panel.timeseries.configuration.new().withSoftLimit(),
    one_steps:        grafana.panel.timeseries.configuration.new().withSoftLimit(50),
    two_steps:        grafana.panel.timeseries.configuration.new().withSoftLimit(50, 90),
  },

  withUnit:       grafana.panel.timeseries.configuration.new().withUnit(grafana.fieldConfig.units.Percent),
}
