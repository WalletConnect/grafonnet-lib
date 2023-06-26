{
  new(
    name,
    matcher     = $.matcher.field,
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
    matcher     = $.matcher.field,
  )::
  {
    matcher: {
      id:       matcher,
      options:  name
    },
    properties: [{
      id: 'color',
      value: {
        mode:       'fixed',
        fixedColor: color
      }
    }]
  },

  matcher:: {
    name::    'byName',
    regexp::  'byRegexp',
    type::    'byType',
    field::   'byFrameRefID',
  },
}
