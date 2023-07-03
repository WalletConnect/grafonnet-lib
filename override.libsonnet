local common = import './common.libsonnet';

{
  new(
    name,
    matcher     = common.fieldMatcher.ByFrameRefID,
    properties  = [],
  )::
  {
    matcher: {
      id:       matcher,
      options:  name
    },
    properties: properties
  },

  newColorOverride(
    name,
    color,
    matcher     = common.fieldMatcher.ByFrameRefID,
  )::
  {
    matcher: {
      id:       matcher,
      options:  name
    },
    properties: [{
      id: 'color',
      value: {
        mode:       common.fieldColorMode.Fixed,
        fixedColor: color
      }
    }]
  },
}
