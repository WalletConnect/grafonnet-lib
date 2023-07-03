local common  = import '../common.libsonnet';

{
  defaultTimeUnit:: common.Milliseconds,
  defaultSizeUnit:: common.KB,

  // Bin
  KiB: std.pow(1024, 1),  // Kibibyte
  MiB: std.pow(1024, 2),  // Mebibyte
  GiB: std.pow(1024, 3),  // Gibibyte
  TiB: std.pow(1024, 4),  // Tebibyte
  PiB: std.pow(1024, 5),  // Pebibyte
  EiB: std.pow(1024, 6),  // Exbibyte
  ZiB: std.pow(1024, 7),  // Zebibyte
  YiB: std.pow(1024, 8),  // Yobibyte

  // Dec
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

  to:: {
    ////////////////////////////////////////////////
    // Time
    nanoseconds(value, from = $.defaultTimeUnit)::
            if from == common.units.Nanoseconds   then value
      else  if from == common.units.Microseconds  then value * (1000)
      else  if from == common.units.Milliseconds  then value * (1000 * 1000)
      else  if from == common.units.Seconds       then value * (1000 * 1000 * 1000)
      else  if from == common.units.Minutes       then value * (60 * 1000 * 1000 * 1000)
      else  if from == common.units.Hours         then value * (60 * 60 * 1000 * 1000 * 1000)
      else  if from == common.units.Days          then value * (24 * 60 * 60 * 1000 * 1000 * 1000)
      else  error 'invalid time unit',

    microseconds(value, from = $.defaultTimeUnit)::
            if from == common.units.Nanoseconds   then value / (1000)
      else  if from == common.units.Microseconds  then value
      else  if from == common.units.Milliseconds  then value * (1000)
      else  if from == common.units.Seconds       then value * (1000 * 1000)
      else  if from == common.units.Minutes       then value * (60 * 1000 * 1000)
      else  if from == common.units.Hours         then value * (60 * 60 * 1000 * 1000)
      else  if from == common.units.Days          then value * (24 * 60 * 60 * 1000 * 1000)
      else  error 'invalid time unit',

    milliseconds(value, from = $.defaultTimeUnit)::
            if from == common.units.Nanoseconds   then value / (1000 * 1000)
      else  if from == common.units.Microseconds  then value / (1000)
      else  if from == common.units.Milliseconds  then value
      else  if from == common.units.Seconds       then value * (1000)
      else  if from == common.units.Minutes       then value * (60 * 1000)
      else  if from == common.units.Hours         then value * (60 * 60 * 1000)
      else  if from == common.units.Days          then value * (24 * 60 * 60 * 1000)
      else  error 'invalid time unit',

    seconds(value, from = $.defaultTimeUnit)::
            if from == common.units.Nanoseconds   then value / (1000 * 1000 * 1000)
      else  if from == common.units.Microseconds  then value / (1000 * 1000)
      else  if from == common.units.Milliseconds  then value / (1000)
      else  if from == common.units.Seconds       then value
      else  if from == common.units.Minutes       then value * (60)
      else  if from == common.units.Hours         then value * (60 * 60)
      else  if from == common.units.Days          then value * (24 * 60 * 60)
      else  error 'invalid time unit',

    minutes(value, from = $.defaultTimeUnit)::
            if from == common.units.Nanoseconds   then value / (60 * 1000 * 1000 * 1000)
      else  if from == common.units.Microseconds  then value / (60 * 1000 * 1000)
      else  if from == common.units.Milliseconds  then value / (60 * 1000)
      else  if from == common.units.Seconds       then value / (60)
      else  if from == common.units.Minutes       then value
      else  if from == common.units.Hours         then value * (60)
      else  if from == common.units.Days          then value * (24 * 60)
      else  error 'invalid time unit',

    hours(value, from = $.defaultTimeUnit)::
            if from == common.units.Nanoseconds   then value / (60 * 60 * 1000 * 1000 * 1000)
      else  if from == common.units.Microseconds  then value / (60 * 60 * 1000 * 1000)
      else  if from == common.units.Milliseconds  then value / (60 * 60 * 1000)
      else  if from == common.units.Seconds       then value / (60 * 60)
      else  if from == common.units.Minutes       then value / (60)
      else  if from == common.units.Hours         then value
      else  if from == common.units.Days          then value * (24)
      else  error 'invalid time unit',


    days(value, from = $.defaultTimeUnit)::
            if from == common.units.Nanoseconds   then value / (24 * 60 * 60 * 1000 * 1000 * 1000)
      else  if from == common.units.Microseconds  then value / (24 * 60 * 60 * 1000 * 1000)
      else  if from == common.units.Milliseconds  then value / (24 * 60 * 60 * 1000)
      else  if from == common.units.Seconds       then value / (24 * 60 * 60)
      else  if from == common.units.Minutes       then value / (24 * 60)
      else  if from == common.units.Hours         then value / (24)
      else  if from == common.units.Days          then value
      else  error 'invalid time unit',

    ////////////////////////////////////////////////
    // Size

    bytes(value, from = $.defaultSizeUnit)::
            if from == common.units.Bytes       then value
      else  if from == common.units.Kibibytes   then value * std.pow(1024, 1)
      else  if from == common.units.Mebibytes   then value * std.pow(1024, 2)
      else  if from == common.units.Gibibytes   then value * std.pow(1024, 3)
      else  if from == common.units.Tebibytes   then value * std.pow(1024, 4)
      else  if from == common.units.Pebibytes   then value * std.pow(1024, 5)
      else  if from == common.units.BytesDec    then value
      else  if from == common.units.Kilobytes   then value * std.pow(1000, 1)
      else  if from == common.units.Megabytes   then value * std.pow(1000, 2)
      else  if from == common.units.Gigabytes   then value * std.pow(1000, 3)
      else  if from == common.units.Terabytes   then value * std.pow(1000, 4)
      else  if from == common.units.Petabytes   then value * std.pow(1000, 5)
      else  error 'invalid size unit',

    kibibytes(value, from = $.defaultSizeUnit)::
            if from == common.units.Bytes       then value / std.pow(1024, 1)
      else  if from == common.units.Kibibytes   then value
      else  if from == common.units.Mebibytes   then value * std.pow(1024, 1)
      else  if from == common.units.Gibibytes   then value * std.pow(1024, 2)
      else  if from == common.units.Tebibytes   then value * std.pow(1024, 3)
      else  if from == common.units.Pebibytes   then value * std.pow(1024, 4)
      else  if from == common.units.BytesDec    then value                    / std.pow(1024, 1)
      else  if from == common.units.Kilobytes   then value * std.pow(1000, 1) / std.pow(1024, 1)
      else  if from == common.units.Megabytes   then value * std.pow(1000, 2) / std.pow(1024, 1)
      else  if from == common.units.Gigabytes   then value * std.pow(1000, 3) / std.pow(1024, 1)
      else  if from == common.units.Terabytes   then value * std.pow(1000, 4) / std.pow(1024, 1)
      else  if from == common.units.Petabytes   then value * std.pow(1000, 5) / std.pow(1024, 1)
      else  error 'invalid size unit',

    mebibytes(value, from = $.defaultSizeUnit)::
            if from == common.units.Bytes       then value / std.pow(1024, 2)
      else  if from == common.units.Kibibytes   then value / std.pow(1024, 1)
      else  if from == common.units.Mebibytes   then value
      else  if from == common.units.Gibibytes   then value * std.pow(1024, 1)
      else  if from == common.units.Tebibytes   then value * std.pow(1024, 2)
      else  if from == common.units.Pebibytes   then value * std.pow(1024, 3)
      else  if from == common.units.BytesDec    then value                    / std.pow(1024, 2)
      else  if from == common.units.Kilobytes   then value * std.pow(1000, 1) / std.pow(1024, 2)
      else  if from == common.units.Megabytes   then value * std.pow(1000, 2) / std.pow(1024, 2)
      else  if from == common.units.Gigabytes   then value * std.pow(1000, 3) / std.pow(1024, 2)
      else  if from == common.units.Terabytes   then value * std.pow(1000, 4) / std.pow(1024, 2)
      else  if from == common.units.Petabytes   then value * std.pow(1000, 5) / std.pow(1024, 2)
      else  error 'invalid size unit',

    gibibytes(value, from = $.defaultSizeUnit)::
            if from == common.units.Bytes       then value / std.pow(1024, 3)
      else  if from == common.units.Kibibytes   then value / std.pow(1024, 2)
      else  if from == common.units.Mebibytes   then value / std.pow(1024, 1)
      else  if from == common.units.Gibibytes   then value
      else  if from == common.units.Tebibytes   then value * std.pow(1024, 1)
      else  if from == common.units.Pebibytes   then value * std.pow(1024, 2)
      else  if from == common.units.BytesDec    then value                    / std.pow(1024, 3)
      else  if from == common.units.Kilobytes   then value * std.pow(1000, 1) / std.pow(1024, 3)
      else  if from == common.units.Megabytes   then value * std.pow(1000, 2) / std.pow(1024, 3)
      else  if from == common.units.Gigabytes   then value * std.pow(1000, 3) / std.pow(1024, 3)
      else  if from == common.units.Terabytes   then value * std.pow(1000, 4) / std.pow(1024, 3)
      else  if from == common.units.Petabytes   then value * std.pow(1000, 5) / std.pow(1024, 3)
      else  error 'invalid size unit',

    tebibytes(value, from = $.defaultSizeUnit)::
            if from == common.units.Bytes       then value / std.pow(1024, 4)
      else  if from == common.units.Kibibytes   then value / std.pow(1024, 3)
      else  if from == common.units.Mebibytes   then value / std.pow(1024, 2)
      else  if from == common.units.Gibibytes   then value / std.pow(1024, 1)
      else  if from == common.units.Tebibytes   then value
      else  if from == common.units.Pebibytes   then value * std.pow(1024, 1)
      else  if from == common.units.BytesDec    then value                    / std.pow(1024, 4)
      else  if from == common.units.Kilobytes   then value * std.pow(1000, 1) / std.pow(1024, 4)
      else  if from == common.units.Megabytes   then value * std.pow(1000, 2) / std.pow(1024, 4)
      else  if from == common.units.Gigabytes   then value * std.pow(1000, 3) / std.pow(1024, 4)
      else  if from == common.units.Terabytes   then value * std.pow(1000, 4) / std.pow(1024, 4)
      else  if from == common.units.Petabytes   then value * std.pow(1000, 5) / std.pow(1024, 4)
      else  error 'invalid size unit',

    pebibytes(value, from = $.defaultSizeUnit)::
            if from == common.units.Bytes       then value / std.pow(1024, 5)
      else  if from == common.units.Kibibytes   then value / std.pow(1024, 4)
      else  if from == common.units.Mebibytes   then value / std.pow(1024, 3)
      else  if from == common.units.Gibibytes   then value / std.pow(1024, 2)
      else  if from == common.units.Tebibytes   then value / std.pow(1024, 1)
      else  if from == common.units.Pebibytes   then value
      else  if from == common.units.BytesDec    then value                    / std.pow(1024, 5)
      else  if from == common.units.Kilobytes   then value * std.pow(1000, 1) / std.pow(1024, 5)
      else  if from == common.units.Megabytes   then value * std.pow(1000, 2) / std.pow(1024, 5)
      else  if from == common.units.Gigabytes   then value * std.pow(1000, 3) / std.pow(1024, 5)
      else  if from == common.units.Terabytes   then value * std.pow(1000, 4) / std.pow(1024, 5)
      else  if from == common.units.Petabytes   then value * std.pow(1000, 5) / std.pow(1024, 5)
      else  error 'invalid size unit',

    kilobytes(value, from = $.defaultSizeUnit)::
            if from == common.units.Bytes       then value / std.pow(1000, 1)
      else  if from == common.units.Kibibytes   then value * std.pow(1024, 1) / std.pow(1000, 1)
      else  if from == common.units.Mebibytes   then value * std.pow(1024, 2) / std.pow(1000, 1)
      else  if from == common.units.Gibibytes   then value * std.pow(1024, 3) / std.pow(1000, 1)
      else  if from == common.units.Tebibytes   then value * std.pow(1024, 4) / std.pow(1000, 1)
      else  if from == common.units.Pebibytes   then value * std.pow(1024, 5) / std.pow(1000, 1)
      else  if from == common.units.BytesDec    then value / std.pow(1000, 1)
      else  if from == common.units.Kilobytes   then value
      else  if from == common.units.Megabytes   then value * std.pow(1000, 1)
      else  if from == common.units.Gigabytes   then value * std.pow(1000, 2)
      else  if from == common.units.Terabytes   then value * std.pow(1000, 3)
      else  if from == common.units.Petabytes   then value * std.pow(1000, 4)
      else  error 'invalid size unit',

    megabytes(value, from = $.defaultSizeUnit)::
            if from == common.units.Bytes       then value / std.pow(1000, 2)
      else  if from == common.units.Kibibytes   then value * std.pow(1024, 1) / std.pow(1000, 2)
      else  if from == common.units.Mebibytes   then value * std.pow(1024, 2) / std.pow(1000, 2)
      else  if from == common.units.Gibibytes   then value * std.pow(1024, 3) / std.pow(1000, 2)
      else  if from == common.units.Tebibytes   then value * std.pow(1024, 4) / std.pow(1000, 2)
      else  if from == common.units.Pebibytes   then value * std.pow(1024, 5) / std.pow(1000, 2)
      else  if from == common.units.BytesDec    then value / std.pow(1000, 2)
      else  if from == common.units.Kilobytes   then value / std.pow(1000, 1)
      else  if from == common.units.Megabytes   then value
      else  if from == common.units.Gigabytes   then value * std.pow(1000, 1)
      else  if from == common.units.Terabytes   then value * std.pow(1000, 2)
      else  if from == common.units.Petabytes   then value * std.pow(1000, 3)
      else  error 'invalid size unit',

    gigabytes(value, from = $.defaultSizeUnit)::
            if from == common.units.Bytes       then value / std.pow(1000, 3)
      else  if from == common.units.Kibibytes   then value * std.pow(1024, 1) / std.pow(1000, 3)
      else  if from == common.units.Mebibytes   then value * std.pow(1024, 2) / std.pow(1000, 3)
      else  if from == common.units.Gibibytes   then value * std.pow(1024, 3) / std.pow(1000, 3)
      else  if from == common.units.Tebibytes   then value * std.pow(1024, 4) / std.pow(1000, 3)
      else  if from == common.units.Pebibytes   then value * std.pow(1024, 5) / std.pow(1000, 3)
      else  if from == common.units.BytesDec    then value / std.pow(1000, 3)
      else  if from == common.units.Kilobytes   then value / std.pow(1000, 2)
      else  if from == common.units.Megabytes   then value / std.pow(1000, 1)
      else  if from == common.units.Gigabytes   then value
      else  if from == common.units.Terabytes   then value * std.pow(1000, 1)
      else  if from == common.units.Petabytes   then value * std.pow(1000, 2)
      else  error 'invalid size unit',

    terabytes(value, from = $.defaultSizeUnit)::
            if from == common.units.Bytes       then value / std.pow(1000, 4)
      else  if from == common.units.Kibibytes   then value * std.pow(1024, 1) / std.pow(1000, 4)
      else  if from == common.units.Mebibytes   then value * std.pow(1024, 2) / std.pow(1000, 4)
      else  if from == common.units.Gibibytes   then value * std.pow(1024, 3) / std.pow(1000, 4)
      else  if from == common.units.Tebibytes   then value * std.pow(1024, 4) / std.pow(1000, 4)
      else  if from == common.units.Pebibytes   then value * std.pow(1024, 5) / std.pow(1000, 4)
      else  if from == common.units.BytesDec    then value / std.pow(1000, 4)
      else  if from == common.units.Kilobytes   then value / std.pow(1000, 3)
      else  if from == common.units.Megabytes   then value / std.pow(1000, 2)
      else  if from == common.units.Gigabytes   then value / std.pow(1000, 1)
      else  if from == common.units.Terabytes   then value
      else  if from == common.units.Petabytes   then value * std.pow(1000, 1)
      else  error 'invalid size unit',

    petabytes(value, from = $.defaultSizeUnit)::
            if from == common.units.Bytes       then value / std.pow(1000, 5)
      else  if from == common.units.Kibibytes   then value * std.pow(1024, 1) / std.pow(1000, 5)
      else  if from == common.units.Mebibytes   then value * std.pow(1024, 2) / std.pow(1000, 5)
      else  if from == common.units.Gibibytes   then value * std.pow(1024, 3) / std.pow(1000, 5)
      else  if from == common.units.Tebibytes   then value * std.pow(1024, 4) / std.pow(1000, 5)
      else  if from == common.units.Pebibytes   then value * std.pow(1024, 5) / std.pow(1000, 5)
      else  if from == common.units.BytesDec    then value / std.pow(1000, 5)
      else  if from == common.units.Kilobytes   then value / std.pow(1000, 4)
      else  if from == common.units.Megabytes   then value / std.pow(1000, 3)
      else  if from == common.units.Gigabytes   then value / std.pow(1000, 2)
      else  if from == common.units.Terabytes   then value / std.pow(1000, 1)
      else  if from == common.units.Petabytes   then value
      else  error 'invalid size unit',
  },

  from:: {
    ////////////////////////////////////////////////
    // Time
    nanoseconds(value, to = $.defaultTimeUnit)::
            if to == common.units.Nanoseconds   then value
      else  if to == common.units.Microseconds  then value / (1000)
      else  if to == common.units.Milliseconds  then value / (1000 * 1000)
      else  if to == common.units.Seconds       then value / (1000 * 1000 * 1000)
      else  if to == common.units.Minutes       then value / (60 * 1000 * 1000 * 1000)
      else  if to == common.units.Hours         then value / (60 * 60 * 1000 * 1000 * 1000)
      else  if to == common.units.Days          then value / (24 * 60 * 60 * 1000 * 1000 * 1000)
      else  error 'invalid time unit',

    microseconds(value, to = $.defaultTimeUnit)::
            if to == common.units.Nanoseconds   then value * (1000)
      else  if to == common.units.Microseconds  then value
      else  if to == common.units.Milliseconds  then value / (1000)
      else  if to == common.units.Seconds       then value / (1000 * 1000)
      else  if to == common.units.Minutes       then value / (60 * 1000 * 1000)
      else  if to == common.units.Hours         then value / (60 * 60 * 1000 * 1000)
      else  if to == common.units.Days          then value / (24 * 60 * 60 * 1000 * 1000)
      else  error 'invalid time unit',

    milliseconds(value, to = $.defaultTimeUnit)::
            if to == common.units.Nanoseconds   then value * (1000 * 1000)
      else  if to == common.units.Microseconds  then value * (1000)
      else  if to == common.units.Milliseconds  then value
      else  if to == common.units.Seconds       then value / (1000)
      else  if to == common.units.Minutes       then value / (60 * 1000)
      else  if to == common.units.Hours         then value / (60 * 60 * 1000)
      else  if to == common.units.Days          then value / (24 * 60 * 60 * 1000)
      else  error 'invalid time unit',

    seconds(value, to = $.defaultTimeUnit)::
            if to == common.units.Nanoseconds   then value * (1000 * 1000 * 1000)
      else  if to == common.units.Microseconds  then value * (1000 * 1000)
      else  if to == common.units.Milliseconds  then value * (1000)
      else  if to == common.units.Seconds       then value
      else  if to == common.units.Minutes       then value / (60)
      else  if to == common.units.Hours         then value / (60 * 60)
      else  if to == common.units.Days          then value / (24 * 60 * 60)
      else  error 'invalid time unit',

    minutes(value, to = $.defaultTimeUnit)::
            if to == common.units.Nanoseconds   then value * (60 * 1000 * 1000 * 1000)
      else  if to == common.units.Microseconds  then value * (60 * 1000 * 1000)
      else  if to == common.units.Milliseconds  then value * (60 * 1000)
      else  if to == common.units.Seconds       then value * (60)
      else  if to == common.units.Minutes       then value
      else  if to == common.units.Hours         then value / (60)
      else  if to == common.units.Days          then value / (24 * 60)
      else  error 'invalid time unit',

    hours(value, to = $.defaultTimeUnit)::
            if to == common.units.Nanoseconds   then value * (60 * 60 * 1000 * 1000 * 1000)
      else  if to == common.units.Microseconds  then value * (60 * 60 * 1000 * 1000)
      else  if to == common.units.Milliseconds  then value * (60 * 60 * 1000)
      else  if to == common.units.Seconds       then value * (60 * 60)
      else  if to == common.units.Minutes       then value * (60)
      else  if to == common.units.Hours         then value
      else  if to == common.units.Days          then value / (24)
      else  error 'invalid time unit',


    days(value, to = $.defaultTimeUnit)::
            if to == common.units.Nanoseconds   then value * (24 * 60 * 60 * 1000 * 1000 * 1000)
      else  if to == common.units.Microseconds  then value * (24 * 60 * 60 * 1000 * 1000)
      else  if to == common.units.Milliseconds  then value * (24 * 60 * 60 * 1000)
      else  if to == common.units.Seconds       then value * (24 * 60 * 60)
      else  if to == common.units.Minutes       then value * (24 * 60)
      else  if to == common.units.Hours         then value * (24)
      else  if to == common.units.Days          then value
      else  error 'invalid time unit',

    ////////////////////////////////////////////////
    // Size

    bytes(value, to = $.defaultSizeUnit)::
            if to == common.units.Bytes       then value
      else  if to == common.units.Kibibytes   then value / std.pow(1024, 1)
      else  if to == common.units.Mebibytes   then value / std.pow(1024, 2)
      else  if to == common.units.Gibibytes   then value / std.pow(1024, 3)
      else  if to == common.units.Tebibytes   then value / std.pow(1024, 4)
      else  if to == common.units.Pebibytes   then value / std.pow(1024, 5)
      else  if to == common.units.BytesDec    then value
      else  if to == common.units.Kilobytes   then value / std.pow(1000, 1)
      else  if to == common.units.Megabytes   then value / std.pow(1000, 2)
      else  if to == common.units.Gigabytes   then value / std.pow(1000, 3)
      else  if to == common.units.Terabytes   then value / std.pow(1000, 4)
      else  if to == common.units.Petabytes   then value / std.pow(1000, 5)
      else  error 'invalid size unit',

    kibibytes(value, to = $.defaultSizeUnit)::
            if to == common.units.Bytes       then value * std.pow(1024, 1)
      else  if to == common.units.Kibibytes   then value
      else  if to == common.units.Mebibytes   then value / std.pow(1024, 1)
      else  if to == common.units.Gibibytes   then value / std.pow(1024, 2)
      else  if to == common.units.Tebibytes   then value / std.pow(1024, 3)
      else  if to == common.units.Pebibytes   then value / std.pow(1024, 4)
      else  if to == common.units.BytesDec    then value * std.pow(1024, 1)
      else  if to == common.units.Kilobytes   then value * std.pow(1024, 1) / std.pow(1000, 1)
      else  if to == common.units.Megabytes   then value * std.pow(1024, 1) / std.pow(1000, 2)
      else  if to == common.units.Gigabytes   then value * std.pow(1024, 1) / std.pow(1000, 3)
      else  if to == common.units.Terabytes   then value * std.pow(1024, 1) / std.pow(1000, 4)
      else  if to == common.units.Petabytes   then value * std.pow(1024, 1) / std.pow(1000, 5)
      else  error 'invalid size unit',

    mebibytes(value, to = $.defaultSizeUnit)::
            if to == common.units.Bytes       then value * std.pow(1024, 2)
      else  if to == common.units.Kibibytes   then value * std.pow(1024, 1)
      else  if to == common.units.Mebibytes   then value
      else  if to == common.units.Gibibytes   then value / std.pow(1024, 1)
      else  if to == common.units.Tebibytes   then value / std.pow(1024, 2)
      else  if to == common.units.Pebibytes   then value / std.pow(1024, 3)
      else  if to == common.units.BytesDec    then value * std.pow(1024, 2)
      else  if to == common.units.Kilobytes   then value * std.pow(1024, 2) / std.pow(1000, 1)
      else  if to == common.units.Megabytes   then value * std.pow(1024, 2) / std.pow(1000, 2)
      else  if to == common.units.Gigabytes   then value * std.pow(1024, 2) / std.pow(1000, 3)
      else  if to == common.units.Terabytes   then value * std.pow(1024, 2) / std.pow(1000, 4)
      else  if to == common.units.Petabytes   then value * std.pow(1024, 2) / std.pow(1000, 5)
      else  error 'invalid size unit',

    gibibytes(value, to = $.defaultSizeUnit)::
            if to == common.units.Bytes       then value * std.pow(1024, 3)
      else  if to == common.units.Kibibytes   then value * std.pow(1024, 2)
      else  if to == common.units.Mebibytes   then value * std.pow(1024, 1)
      else  if to == common.units.Gibibytes   then value
      else  if to == common.units.Tebibytes   then value / std.pow(1024, 1)
      else  if to == common.units.Pebibytes   then value / std.pow(1024, 2)
      else  if to == common.units.BytesDec    then value * std.pow(1024, 3)
      else  if to == common.units.Kilobytes   then value * std.pow(1024, 3) / std.pow(1000, 1)
      else  if to == common.units.Megabytes   then value * std.pow(1024, 3) / std.pow(1000, 2)
      else  if to == common.units.Gigabytes   then value * std.pow(1024, 3) / std.pow(1000, 3)
      else  if to == common.units.Terabytes   then value * std.pow(1024, 3) / std.pow(1000, 4)
      else  if to == common.units.Petabytes   then value * std.pow(1024, 3) / std.pow(1000, 5)
      else  error 'invalid size unit',

    tebibytes(value, to = $.defaultSizeUnit)::
            if to == common.units.Bytes       then value * std.pow(1024, 4)
      else  if to == common.units.Kibibytes   then value * std.pow(1024, 3)
      else  if to == common.units.Mebibytes   then value * std.pow(1024, 2)
      else  if to == common.units.Gibibytes   then value * std.pow(1024, 1)
      else  if to == common.units.Tebibytes   then value
      else  if to == common.units.Pebibytes   then value / std.pow(1024, 1)
      else  if to == common.units.BytesDec    then value * std.pow(1024, 4)
      else  if to == common.units.Kilobytes   then value * std.pow(1024, 4) / std.pow(1000, 1)
      else  if to == common.units.Megabytes   then value * std.pow(1024, 4) / std.pow(1000, 2)
      else  if to == common.units.Gigabytes   then value * std.pow(1024, 4) / std.pow(1000, 3)
      else  if to == common.units.Terabytes   then value * std.pow(1024, 4) / std.pow(1000, 4)
      else  if to == common.units.Petabytes   then value * std.pow(1024, 4) / std.pow(1000, 5)
      else  error 'invalid size unit',

    pebibytes(value, to = $.defaultSizeUnit)::
            if to == common.units.Bytes       then value * std.pow(1024, 5)
      else  if to == common.units.Kibibytes   then value * std.pow(1024, 4)
      else  if to == common.units.Mebibytes   then value * std.pow(1024, 3)
      else  if to == common.units.Gibibytes   then value * std.pow(1024, 2)
      else  if to == common.units.Tebibytes   then value * std.pow(1024, 1)
      else  if to == common.units.Pebibytes   then value
      else  if to == common.units.BytesDec    then value * std.pow(1024, 5)
      else  if to == common.units.Kilobytes   then value * std.pow(1024, 5) / std.pow(1000, 1)
      else  if to == common.units.Megabytes   then value * std.pow(1024, 5) / std.pow(1000, 2)
      else  if to == common.units.Gigabytes   then value * std.pow(1024, 5) / std.pow(1000, 3)
      else  if to == common.units.Terabytes   then value * std.pow(1024, 5) / std.pow(1000, 4)
      else  if to == common.units.Petabytes   then value * std.pow(1024, 5) / std.pow(1000, 5)
      else  error 'invalid size unit',

    kilobytes(value, to = $.defaultSizeUnit)::
            if to == common.units.Bytes       then value * std.pow(1000, 1)
      else  if to == common.units.Kibibytes   then value * std.pow(1000, 1) / std.pow(1024, 1)
      else  if to == common.units.Mebibytes   then value * std.pow(1000, 1) / std.pow(1024, 2)
      else  if to == common.units.Gibibytes   then value * std.pow(1000, 1) / std.pow(1024, 3)
      else  if to == common.units.Tebibytes   then value * std.pow(1000, 1) / std.pow(1024, 4)
      else  if to == common.units.Pebibytes   then value * std.pow(1000, 1) / std.pow(1024, 5)
      else  if to == common.units.BytesDec    then value * std.pow(1000, 1)
      else  if to == common.units.Kilobytes   then value
      else  if to == common.units.Megabytes   then value / std.pow(1000, 1)
      else  if to == common.units.Gigabytes   then value / std.pow(1000, 2)
      else  if to == common.units.Terabytes   then value / std.pow(1000, 3)
      else  if to == common.units.Petabytes   then value / std.pow(1000, 4)
      else  error 'invalid size unit',

    megabytes(value, to = $.defaultSizeUnit)::
            if to == common.units.Bytes       then value * std.pow(1000, 2)
      else  if to == common.units.Kibibytes   then value * std.pow(1000, 2) / std.pow(1024, 1)
      else  if to == common.units.Mebibytes   then value * std.pow(1000, 2) / std.pow(1024, 2)
      else  if to == common.units.Gibibytes   then value * std.pow(1000, 2) / std.pow(1024, 3)
      else  if to == common.units.Tebibytes   then value * std.pow(1000, 2) / std.pow(1024, 4)
      else  if to == common.units.Pebibytes   then value * std.pow(1000, 2) / std.pow(1024, 5)
      else  if to == common.units.BytesDec    then value * std.pow(1000, 2)
      else  if to == common.units.Kilobytes   then value * std.pow(1000, 1)
      else  if to == common.units.Megabytes   then value
      else  if to == common.units.Gigabytes   then value / std.pow(1000, 1)
      else  if to == common.units.Terabytes   then value / std.pow(1000, 2)
      else  if to == common.units.Petabytes   then value / std.pow(1000, 3)
      else  error 'invalid size unit',

    gigabytes(value, to = $.defaultSizeUnit)::
            if to == common.units.Bytes       then value * std.pow(1000, 3)
      else  if to == common.units.Kibibytes   then value * std.pow(1000, 3) / std.pow(1024, 1)
      else  if to == common.units.Mebibytes   then value * std.pow(1000, 3) / std.pow(1024, 2)
      else  if to == common.units.Gibibytes   then value * std.pow(1000, 3) / std.pow(1024, 3)
      else  if to == common.units.Tebibytes   then value * std.pow(1000, 3) / std.pow(1024, 4)
      else  if to == common.units.Pebibytes   then value * std.pow(1000, 3) / std.pow(1024, 5)
      else  if to == common.units.BytesDec    then value * std.pow(1000, 3)
      else  if to == common.units.Kilobytes   then value * std.pow(1000, 2)
      else  if to == common.units.Megabytes   then value * std.pow(1000, 1)
      else  if to == common.units.Gigabytes   then value
      else  if to == common.units.Terabytes   then value / std.pow(1000, 1)
      else  if to == common.units.Petabytes   then value / std.pow(1000, 2)
      else  error 'invalid size unit',

    terabytes(value, to = $.defaultSizeUnit)::
            if to == common.units.Bytes       then value * std.pow(1000, 4)
      else  if to == common.units.Kibibytes   then value * std.pow(1000, 4) / std.pow(1024, 1)
      else  if to == common.units.Mebibytes   then value * std.pow(1000, 4) / std.pow(1024, 2)
      else  if to == common.units.Gibibytes   then value * std.pow(1000, 4) / std.pow(1024, 3)
      else  if to == common.units.Tebibytes   then value * std.pow(1000, 4) / std.pow(1024, 4)
      else  if to == common.units.Pebibytes   then value * std.pow(1000, 4) / std.pow(1024, 5)
      else  if to == common.units.BytesDec    then value * std.pow(1000, 4)
      else  if to == common.units.Kilobytes   then value * std.pow(1000, 3)
      else  if to == common.units.Megabytes   then value * std.pow(1000, 2)
      else  if to == common.units.Gigabytes   then value * std.pow(1000, 1)
      else  if to == common.units.Terabytes   then value
      else  if to == common.units.Petabytes   then value / std.pow(1000, 1)
      else  error 'invalid size unit',

    petabytes(value, to = $.defaultSizeUnit)::
            if to == common.units.Bytes       then value * std.pow(1000, 5)
      else  if to == common.units.Kibibytes   then value * std.pow(1000, 5) / std.pow(1024, 1)
      else  if to == common.units.Mebibytes   then value * std.pow(1000, 5) / std.pow(1024, 2)
      else  if to == common.units.Gibibytes   then value * std.pow(1000, 5) / std.pow(1024, 3)
      else  if to == common.units.Tebibytes   then value * std.pow(1000, 5) / std.pow(1024, 4)
      else  if to == common.units.Pebibytes   then value * std.pow(1000, 5) / std.pow(1024, 5)
      else  if to == common.units.BytesDec    then value * std.pow(1000, 5)
      else  if to == common.units.Kilobytes   then value * std.pow(1000, 4)
      else  if to == common.units.Megabytes   then value * std.pow(1000, 3)
      else  if to == common.units.Gigabytes   then value * std.pow(1000, 2)
      else  if to == common.units.Terabytes   then value * std.pow(1000, 1)
      else  if to == common.units.Petabytes   then value
      else  error 'invalid size unit',
  },
}
