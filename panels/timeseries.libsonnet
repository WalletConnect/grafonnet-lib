local panel = import 'panel.libsonnet';
local fieldConfig = import '../field_config.libsonnet';

{
  type:         'timeseries',

  defaults_cfg:: {
    axisPlacement:      $.axisPlacements.Auto,
    barAlignment:       0,
    drawStyle:          'line',
    fillOpacity:        0,
    gradientMode:       $.gradientModes.None,
    hideFrom:           null,
    lineInterpolation:  $.lineInterpolations.Linear,
    lineStyle:          null,
    lineWidth:          1,
    pointSize:          5,
    scaleDistribution:  null,
    showPoints:         $.showPoints.Auto,
    spanNulls:          false,
    stacking:           null,
    thresholdsStyle:    {
      mode: 'off'
    },
  },


  configure(configuration):: self {
    fieldConfig+: configuration.fieldConfig,
    options+:     configuration.options,
  },

  addPanelThreshold(
    op,
    value,
    colorMode = 'critical',
    visible   = true
  ):: self {
    thresholds+: [
      {
        op:       op,
        value:    value,
        colorMode: colorMode,
        visible:   visible,
      },
    ],
  },

  configuration:: {
    new(
      axisGridShow      = null,                             // True to always show the axis grid.
      axisLabel         = null,                             // Set a Y-axis text label. If you have more than one Y-axis, then you can assign different labels using an override.
      axisPlacement     = $.defaults_cfg.axisPlacement,     // Select the placement of the Y-axis. 'auto', 'left', 'right', 'hidden'.
      axisSoftMax       = null,                             //
      axisSoftMin       = null,                             //
      axisWidth         = null,                             // Set a fixed width of the axis. By default, Grafana dynamically calculates the width of an axis.
      barAlignment      = $.defaults_cfg.barAlignment,      // Set the position of the bar relative to a data point
      drawStyle         = $.defaults_cfg.drawStyle,         //
      fillOpacity       = $.defaults_cfg.fillOpacity,       //
      gradientMode      = $.defaults_cfg.gradientMode,      //
      hideFrom          = null,                             //
      lineInterpolation = $.defaults_cfg.lineInterpolation, //
      lineStyle         = null,                             //
      lineWidth         = $.defaults_cfg.lineWidth,         //
      pointSize         = $.defaults_cfg.pointSize,         //
      scaleDistribution = null,                             //
      showPoints        = $.defaults_cfg.showPoints,        //
      spanNulls         = $.defaults_cfg.spanNulls,         //
      stacking          = null,                             //
      thresholdsStyle   = $.defaults_cfg.thresholdsStyle,   //
      legend            = null,                             //
      tooltip           = null,                             //
    ):: {
      fieldConfig: fieldConfig.new(
        custom = {
          [if axisGridShow      != null then 'axisGridShow'     ]:  axisGridShow,
          [if axisLabel         != null then 'axisLabel'        ]:  axisLabel,
          [if axisPlacement     != null then 'axisPlacement'    ]:  axisPlacement,
          [if axisSoftMax       != null then 'axisSoftMax'      ]:  axisSoftMax,
          [if axisSoftMin       != null then 'axisSoftMin'      ]:  axisSoftMin,
          [if axisWidth         != null then 'axisWidth'        ]:  axisWidth,
          [if barAlignment      != null then 'barAlignment'     ]:  barAlignment,
          [if drawStyle         != null then 'drawStyle'        ]:  drawStyle,
          [if fillOpacity       != null then 'fillOpacity'      ]:  fillOpacity,
          [if gradientMode      != null then 'gradientMode'     ]:  gradientMode,
          [if hideFrom          != null then 'hideFrom'         ]:  hideFrom,
          [if hideFrom          != null then 'hideFrom'         ]:  hideFrom,
          [if lineStyle         != null then 'lineStyle'        ]:  lineStyle,
          [if lineWidth         != null then 'lineWidth'        ]:  lineWidth,
          [if pointSize         != null then 'pointSize'        ]:  pointSize,
          [if scaleDistribution != null then 'scaleDistribution']:  scaleDistribution,
          [if showPoints        != null then 'showPoints'       ]:  showPoints,
          [if spanNulls         != null then 'spanNulls'        ]:  spanNulls,
          [if stacking          != null then 'stacking'         ]:  stacking,
          [if thresholdsStyle   != null then 'thresholdsStyle'  ]:  thresholdsStyle,
        }
      ),
      options: {
        [if legend  != null then 'legend' ]:  legend,
        [if tooltip != null then 'tooltip']:  tooltip,
      },


      withThresholds(baseColor, steps = [])::             $.withThresholds    (self, baseColor, steps),
      withThresholdStyle(style)::                         $.withThresholdStyle(self, style),
      addThreshold(threshold)::                           $.addThreshold      (self, threshold),
      addThresholds(steps)::                              $.addThresholds     (self, steps),
      addOverride(override)::                             $.addOverride       (self, override),
      addOverrides(overrides)::                           $.addOverrides      (self, overrides),
      addMapping(mapping)::                               $.addMapping        (self, mapping),
      addMappings(mappings)::                             $.addMappings       (self, mappings),
      withColor(mode, fixedColor = null)::                $.withColor         (self, mode, fixedColor),
      withSoftLimit(axisSoftMin = 0,axisSoftMax = 100)::  $.withSoftLimit     (self, axisSoftMin, axisSoftMax),
      withUnit(unit)::                                    $.withUnit          (self, unit),
      withSpanNulls(spanNulls)::                          $.withSpanNulls     (self, spanNulls),
    },
  },

  withThresholds(_self, baseColor, steps = []):: _self {
    fieldConfig+: {
      defaults+: {
        thresholds: {
          steps: [
            {
              color: baseColor,
              value: null
            }
          ] + steps,
        }
      },
    },
  },
  withThresholdStyle(_self, style):: _self {
    fieldConfig+: {
      defaults+: {
        custom+: {
          thresholdsStyle+: {
            mode: style,
          },
        },
      },
    },
  },
  addThreshold(_self, threshold):: _self {
    fieldConfig+: {
      defaults+: {
        thresholds+: {
          steps+: [threshold],
        }
      }
    }
  },
  addThresholds(_self, steps):: std.foldl(function(p, s) p.addThreshold(s), steps, _self),

  addOverride(_self, override):: _self {
    fieldConfig+: {
      overrides+: [override],
    }
  },
  addOverrides(_self, overrides):: std.foldl(function(p, s) p.addOverride(s), overrides, _self),

  addMapping(_self, mapping):: _self {
    fieldConfig+: {
      defaults+: {
        mappings+: [mapping],
      }
    }
  },
  addMappings(_self, mappings):: std.foldl(function(p, m) p.addMapping(m), mappings, _self),

  withColor(_self, mode, fixedColor = null):: _self {
    fieldConfig+: {
      defaults+: {
        color: {
          mode: mode,
          [if fixedColor != null then 'fixedColor']: fixedColor,
        },
      },
    }
  },

  withSoftLimit(_self, axisSoftMin = 0, axisSoftMax = 100):: _self {
    fieldConfig+: {
      defaults+: {
        custom+: {
          [if axisSoftMin != null then 'axisSoftMin']: axisSoftMin,
          [if axisSoftMax != null then 'axisSoftMax']: axisSoftMax,
        },
      },
    }
  },

  withUnit(_self, unit):: _self {
    fieldConfig+: {
      defaults+: {
        unit: unit,
      },
    }
  },

  withSpanNulls(_self, spanNulls):: _self {
    fieldConfig+: {
      custom+: {
        spanNulls: spanNulls,
      },
    },
  },


  //////////////////////////////////////////////////////////////////////////////
  // Constants

  axisPlacements:: {
    Auto:     'auto',
    Left:     'left',
    Right:    'right',
    Hidden:   'hidden',
  },

  gradientModes:: {
    None:     'none',
    Opacity:  'opacity',
    Hue:      'hue',
  },

  lineInterpolations:: {
    Linear:   'linear',
    Smooth:   'smooth',
  },

  showPoints:: {
    Auto:     'auto',
    Always:   'always',
    Never:    'never',
  },

} + panel
