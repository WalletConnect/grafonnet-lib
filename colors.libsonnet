{
  Red::                   'red',
  Orange::                'orange',
  Yellow::                'yellow',
  Green::                 'green',
  Blue::                  'blue',
  Purple::                'purple',

  shades:: {
    Dark::                'dark',
    SemiDark::            'semi-dark',
    SemiLight::           'semi-light',
    Light::               'light',
  },

  getShade(color, shade)::
    if std.length(std.find(shade, std.objectValues($.shades))) != 0 then
      shade + '-' + color
    else
      error 'Invalid shade: ' + shade + ' for color: ' + color,
}
