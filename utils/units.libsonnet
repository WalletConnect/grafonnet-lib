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

  capitalize(str):: "%s%s" % [
    std.asciiUpper(std.substr(str, 0, 1)),
    std.asciiLower(std.substr(str, 1, std.length(str) - 1))
  ],

  sizeof_fmt(num, suffix="B"):: if num < std.pow(1024, 8) then [
    x.fmt % x.val + x.unit + suffix for x in [
      { unit: "",   val: num,                    fmt: "%0d"   },
      { unit: "Ki", val: num / std.pow(1024, 1), fmt: "%0.2f" },
      { unit: "Mi", val: num / std.pow(1024, 2), fmt: "%0.2f" },
      { unit: "Gi", val: num / std.pow(1024, 3), fmt: "%0.2f" },
      { unit: "Ti", val: num / std.pow(1024, 4), fmt: "%0.2f" },
      { unit: "Pi", val: num / std.pow(1024, 5), fmt: "%0.2f" },
      { unit: "Ei", val: num / std.pow(1024, 6), fmt: "%0.2f" },
      { unit: "Zi", val: num / std.pow(1024, 7), fmt: "%0.2f" },
    ] if std.abs(x.val) < 1024.0
  ][0] else "> 1 Yi" + suffix,
}
