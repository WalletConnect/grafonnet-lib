{
  capitalize(str)::
          if std.length(str) == 0 then ''
    else  if std.length(str) == 1 then std.asciiUpper(str)
    else std.asciiUpper(std.substr(str, 0, 1)) + std.asciiLower(std.substr(str, 1, std.length(str) - 1)),

  sizeof_fmt(num, suffix="B"):: if num < std.pow(1024, 8) then [
    x.fmt % x.val + x.unit + suffix for x in [
      { unit: '',   val: num,                    fmt: '%0d'   },
      { unit: 'Ki', val: num / std.pow(1024, 1), fmt: '%0.2f' },
      { unit: 'Mi', val: num / std.pow(1024, 2), fmt: '%0.2f' },
      { unit: 'Gi', val: num / std.pow(1024, 3), fmt: '%0.2f' },
      { unit: 'Ti', val: num / std.pow(1024, 4), fmt: '%0.2f' },
      { unit: 'Pi', val: num / std.pow(1024, 5), fmt: '%0.2f' },
      { unit: 'Ei', val: num / std.pow(1024, 6), fmt: '%0.2f' },
      { unit: 'Zi', val: num / std.pow(1024, 7), fmt: '%0.2f' },
    ] if std.abs(x.val) < 1024.0
  ][0] else '> 1 Yi' + suffix,
}
