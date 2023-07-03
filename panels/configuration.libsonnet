local fieldConfig = import '../field_config.libsonnet';
local common = import '../common.libsonnet';

{
  _new(
    legend  = null,
    tooltip = common.tooltipDisplayMode.Single,
  ):: {
    fieldConfig: fieldConfig.new(),
    options: {
      [if legend  != null then 'legend' ]:  legend,
      [if tooltip != null then 'tooltip']:  tooltip,
    },

    addOverride(override)::                             $.addOverride       (self, override),
    addOverrides(overrides)::                           $.addOverrides      (self, overrides),
  },

  addOverride(_self, override):: _self {
    fieldConfig+: {
      overrides+: [override],
    }
  },
  addOverrides(_self, overrides):: std.foldl(function(p, s) p.addOverride(s), overrides, _self),

  GraphFieldConfig:: {
    drawStyle:         common.graphDrawStyle.Line,
    lineInterpolation: common.lineInterpolation.Linear,
    lineWidth:         1,
    fillOpacity:       0,
    gradientMode:      common.graphGradientMode.None,
    barAlignment:      common.barAlignment.Center,
    stacking:          {
      mode:   common.stackingMode.None,
      group:  'A',
    },
    axisGridShow:      true,
    axisCenteredZero:  false,
  },
}
