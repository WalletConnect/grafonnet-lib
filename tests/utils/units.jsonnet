local units = import '../../utils/units.libsonnet';

{
  bin: {
    KiB: std.assertEqual(units.bin.KiB, 1024),
    MiB: std.assertEqual(units.bin.MiB, 1048576),
    GiB: std.assertEqual(units.bin.GiB, 1073741824),
    TiB: std.assertEqual(units.bin.TiB, 1099511627776),
    PiB: std.assertEqual(units.bin.PiB, 1125899906842624),
    EiB: std.assertEqual(units.bin.EiB, 1152921504606846976),
    ZiB: std.assertEqual(units.bin.ZiB, 1180591620717411303424),
    YiB: std.assertEqual(units.bin.YiB, 1208925819614629174706176),
  },
  dec: {
    KB: std.assertEqual(units.dec.KB, 1000),
    MB: std.assertEqual(units.dec.MB, 1000000),
    GB: std.assertEqual(units.dec.GB, 1000000000),
    TB: std.assertEqual(units.dec.TB, 1000000000000),
    PB: std.assertEqual(units.dec.PB, 1000000000000000),
    EB: std.assertEqual(units.dec.EB, 1000000000000000000),
    ZB: std.assertEqual(units.dec.ZB, 1000000000000000000000),
    YB: std.assertEqual(units.dec.YB, 1000000000000000000000000),
    RB: std.assertEqual(units.dec.RB, 1000000000000000000000000000),
    QB: std.assertEqual(units.dec.QB, 1000000000000000000000000000000),
  },

  milliseconds: {
    to_milliseconds:  std.assertEqual(units.milliseconds(1, units.time.Milliseconds), 1),
    to_seconds:       std.assertEqual(units.milliseconds(1, units.time.Seconds),      1 / 1000),
    to_minutes:       std.assertEqual(units.milliseconds(1, units.time.Minutes),      1 / 1000 / 60),
  },
  seconds: {
    to_milliseconds:  std.assertEqual(units.seconds(1, units.time.Milliseconds),      1000),
    to_seconds:       std.assertEqual(units.seconds(1, units.time.Seconds),           1),
    to_minutes:       std.assertEqual(units.seconds(1, units.time.Minutes),           1 / 60),
  },
  minutes: {
    to_milliseconds:  std.assertEqual(units.minutes(1, units.time.Milliseconds),      1 * 60 * 1000),
    to_seconds:       std.assertEqual(units.minutes(1, units.time.Seconds),           1 * 60),
    to_minutes:       std.assertEqual(units.minutes(1, units.time.Minutes),           1),
  },

  size_bin: {
    KiB:  std.assertEqual(units.size_bin(KiB = 1), 1024),
    MiB:  std.assertEqual(units.size_bin(MiB = 1), 1048576),
    GiB:  std.assertEqual(units.size_bin(GiB = 1), 1073741824),
    TiB:  std.assertEqual(units.size_bin(TiB = 1), 1099511627776),
    PiB:  std.assertEqual(units.size_bin(PiB = 1), 1125899906842624),
    EiB:  std.assertEqual(units.size_bin(EiB = 1), 1152921504606846976),
    ZiB:  std.assertEqual(units.size_bin(ZiB = 1), 1180591620717411303424),
    YiB:  std.assertEqual(units.size_bin(YiB = 1), 1208925819614629174706176),
  },

  size_dec: {
    KB:   std.assertEqual(units.size_dec(KB = 1), 1000),
    MB:   std.assertEqual(units.size_dec(MB = 1), 1000000),
    GB:   std.assertEqual(units.size_dec(GB = 1), 1000000000),
    TB:   std.assertEqual(units.size_dec(TB = 1), 1000000000000),
    PB:   std.assertEqual(units.size_dec(PB = 1), 1000000000000000),
    EB:   std.assertEqual(units.size_dec(EB = 1), 1000000000000000000),
    ZB:   std.assertEqual(units.size_dec(ZB = 1), 1000000000000000000000),
    YB:   std.assertEqual(units.size_dec(YB = 1), 1000000000000000000000000),
  },
}
