{
  bin:: {
    KiB: std.pow(1024, 1),  // Kibibyte
    MiB: std.pow(1024, 2),  // Mebibyte
    GiB: std.pow(1024, 3),  // Gibibyte
    TiB: std.pow(1024, 4),  // Tebibyte
    PiB: std.pow(1024, 5),  // Pebibyte
    EiB: std.pow(1024, 6),  // Exbibyte
    ZiB: std.pow(1024, 7),  // Zebibyte
    YiB: std.pow(1024, 8),  // Yobibyte
  },
  dec:: {
    KB: std.pow(1000, 1),   // Kilobyte
    MB: std.pow(1000, 2),   // Megobyte
    GB: std.pow(1000, 3),   // Gigabyte
    TB: std.pow(1000, 4),   // Terebyte
    PB: std.pow(1000, 5),   // Petabyte
    EB: std.pow(1000, 6),   // Exabyte
    ZB: std.pow(1000, 7),   // Zettabyte
    YB: std.pow(1000, 8),   // Yottabyte
    RB: std.pow(1000, 9),   // Ronnabyte
    QB: std.pow(1000, 10),  // Quettabyte
  },

  time:: {
    Milliseconds: 'ms',
    Seconds:      's',
    Minutes:      'm',
  },

  defaultTimeUnit:: $.time.Milliseconds,

  milliseconds:: function(value, to = $.defaultTimeUnit)
          if to == $.time.Milliseconds  then value
    else  if to == $.time.Seconds       then value / 1000
    else  if to == $.time.Minutes       then value / 60000
    else  error 'invalid time unit',

  seconds:: function(value, to = $.defaultTimeUnit)
          if to == $.time.Milliseconds  then value * 1000
    else  if to == $.time.Seconds       then value
    else  if to == $.time.Minutes       then value / 60
    else  error 'invalid time unit',

  minutes:: function(value, to = $.defaultTimeUnit)
          if to == $.time.Milliseconds  then value * 60000
    else  if to == $.time.Seconds       then value * 60
    else  if to == $.time.Minutes       then value
    else  error 'invalid time unit',

  size_bin:: function(
    KiB = null,
    MiB = null,
    GiB = null,
    TiB = null,
    PiB = null,
    EiB = null,
    ZiB = null,
    YiB = null,
  )      if KiB != null then KiB * $.bin.KiB
    else if MiB != null then MiB * $.bin.MiB
    else if GiB != null then GiB * $.bin.GiB
    else if TiB != null then TiB * $.bin.TiB
    else if PiB != null then PiB * $.bin.PiB
    else if EiB != null then EiB * $.bin.EiB
    else if ZiB != null then ZiB * $.bin.ZiB
    else if YiB != null then YiB * $.bin.YiB
    else error 'no value specified',

  size_dec:: function(
    KB = null,
    MB = null,
    GB = null,
    TB = null,
    PB = null,
    EB = null,
    ZB = null,
    YB = null,
  )      if KB != null then KB * $.dec.KB
    else if MB != null then MB * $.dec.MB
    else if GB != null then GB * $.dec.GB
    else if TB != null then TB * $.dec.TB
    else if PB != null then PB * $.dec.PB
    else if EB != null then EB * $.dec.EB
    else if ZB != null then ZB * $.dec.ZB
    else if YB != null then YB * $.dec.YB
    else error 'no value specified',

}
