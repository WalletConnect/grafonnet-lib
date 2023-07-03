local common = import './common.libsonnet';

{
  defaults:: {
    thresholdsBaseColor:  common.colors.Green,
  },

  new(
    color               = null,   // Map values to a display color.
    custom              = {},
    decimals            = null,   // Significant digits (for display).
    description         = null,   // Human readable field metadata.
    displayName         = null,   // The display value for this field. This supports template variables blank is auto.
    displayNameFromDS   = null,   // This can be used by data sources that return and explicit naming structure for values and labels.
    filterable          = null,   // True if data source field supports ad-hoc filters.
    min                 = null,   // Hard min limit
    max                 = null,   // Hard max limit
    noValue             = null,   // Alternative to empty string.
    path                = null,   // An explicit path to the field in the datasource.
    unit                = null,
    thresholds          = null,
    thresholdsBaseColor = $.defaults.thresholdsBaseColor,
    writeable           = null,   // True if data source can write a value to the path.
    overrides           = null,
  ):: {
    defaults:   {
      color: if color != null then color else {
        mode: common.fieldColorMode.PaletteClassic,
      },
      custom: custom,
      [if decimals !=          null then 'decimals'         ]: decimals,
      [if description !=       null then 'description'      ]: description,
      [if displayName !=       null then 'displayName'      ]: displayName,
      [if displayNameFromDS != null then 'displayNameFromDS']: displayNameFromDS,
      [if filterable !=        null then 'filterable'       ]: filterable,
      [if min !=               null then 'min'              ]: min,
      [if max !=               null then 'max'              ]: max,
      [if noValue !=           null then 'noValue'          ]: noValue,
      [if path !=              null then 'path'             ]: path,
      [if unit !=              null then 'unit'             ]: unit,
      [if writeable !=         null then 'writeable'        ]: writeable,
      mappings: [],

      thresholds: if thresholds != null then thresholds else {
        mode: common.thresholdMode.Absolute,
        steps: [
          {
            color: thresholdsBaseColor,
            value: null
          }
        ]
      },
    },
    overrides:  if overrides != null then overrides else [],

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
  },

  withThresholds(_self, baseColor, steps = []):: _self {
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
  withThresholdStyle(_self, style):: _self {
    defaults+: {
      custom+: {
        thresholdsStyle+: {
          mode: style,
        },
      },
    },
  },
  addThreshold(_self, threshold):: _self {
    defaults+: {
      thresholds+: {
        steps+: [threshold],
      }
    }
  },
  addThresholds(_self, steps):: std.foldl(function(p, s) p.addThreshold(s), steps, _self),

  addOverride(_self, override):: _self {
    overrides+: [override],
  },
  addOverrides(_self, overrides):: std.foldl(function(p, s) p.addOverride(s), overrides, _self),

  addMapping(_self, mapping):: _self {
    defaults+: {
      mappings+: [mapping],
    }
  },
  addMappings(_self, mappings):: std.foldl(function(p, m) p.addMapping(m), mappings, _self),

  withColor(_self, mode, fixedColor = null):: _self {
    defaults+: {
      color: {
        mode: mode,
        [if fixedColor != null then 'fixedColor']: fixedColor,
      },
    },
  },

  withSoftLimit(
    _self,
    axisSoftMin = 0,
    axisSoftMax = 100,
  ):: _self {
    defaults+: {
      custom+: {
        [if axisSoftMin != null then 'axisSoftMin']: axisSoftMin,
        [if axisSoftMax != null then 'axisSoftMax']: axisSoftMax,
      },
    },
  },

  withUnit(_self, unit):: _self {
    defaults+: {
      unit: unit,
    },
  },
}
