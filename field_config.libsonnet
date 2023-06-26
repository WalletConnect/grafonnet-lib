{
  defaults:: {
    thresholdsBaseColor:  'green',
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
        mode: $.colorMode.Classic,
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
        mode: $.thresholdMode.Absolute,
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


  //////////////////////////////////////////////////////////////////////////////
  // Constants

  thresholdMode:: {
    Absolute::                    'absolute',
    Percentage::                  'percentage',
  },

  colorMode:: {
    Fixed::                       'fixed',
    Thresholds::                  'thresholds',
    Classic::                     'palette-classic',
    GreenYellowRed::              'continuous-GrYlRd',
    RedYellowGreen::              'continuous-RdYlGr',
    BlueYellowRed::               'continuous-BlYlRd',
    YellowRed::                   'continuous-YlRd',
    BluePurple::                  'continuous-BlPu',
    YellowBlue::                  'continuous-YlBl',
    Blues::                       'continuous-blues',
    Reds::                        'continuous-reds',
    Greens::                      'continuous-greens',
    Purples::                     'continuous-purples',
  },

  thresholdStyle:: {
    Off::                         'off',
    Line::                        'line',
    Dashed::                      'dashed',
    Area::                        'area',
    LineArea::                    'line+area',
    DashedArea::                  'dashed+area',
    Fill::                        'fill',
  },

  units:: {
    Number::                      'none',
    String::                      'string',
    Short::                       'short',                        // Short
    Percent::                     'percent',                      // Percent (0 - 100)
    PercentUnit::                 'percentunit',                  // Percent (0.0 - 1.0))
    Hex0x::                       'hex0x',                        // Hexadecimal with 0x prefix
    Hex::                         'hex',                          // Hexadecimal
    Scientific::                  'sci',                          // Scientific notation
    Local::                       'locale',                       // Localized number

    Bits::                        'bits',                         // Bits (IEC)
    Bytes::                       'bytes',                        // Bytes (IEC)
    Kibibytes::                   'kbytes',                       // Kibibytes (IEC)
    Mebibytes::                   'mbytes',                       // Mebibytes (IEC)
    Gigibytes::                   'gbytes',                       // Gigibytes (IEC)
    Tebibytes::                   'tbytes',                       // Tebibytes (IEC)
    Pebibytes::                   'pbytes',                       // Pebibytes (IEC)

    DecBits::                     'decbits',                      // Bits (DEC)
    DecBytes::                    'decbytes',                     // Bytes (DEC)
    Kilobytes::                   'deckbytes',                    // Kilobytes (DEC)
    Megabytes::                   'decmbytes',                    // Megabytes (DEC)
    Gigabytes::                   'decgbytes',                    // Gigabytes (DEC)
    Terabytes::                   'dectbytes',                    // Terabytes (DEC)
    Petabytes::                   'decpbytes',                    // Petabytes (DEC)

    PacketPerSecond::             'pps',                          // Packets per second

    BitsPerSecond::               'binbps',                       // Bits per second (IEC)
    KibibitsPerSecond::           'Kibits',                       // Kibibits per second (IEC)
    MebibitePerSeconds::          'MiBs',                         // Mebibits per second (IEC)
    GigibitsPerSeconds::          'Gibits',                       // Gigibits per second (IEC)
    TebibitsPerSeconds::          'Tibits',                       // Tebibits per second (IEC)
    PebibitsPerSeconds::          'Pibits',                       // Pebibits per second (IEC)

    BitsPerSecondDec::            'bps',                          // Bits per second (DEC)
    KilobitsPerSecond::           'Kbits',                        // Kilobits per second (DEC)
    MegabitsPerSeconds::          'Mbits',                        // Megabits per second (DEC)
    GigabitsPerSeconds::          'Gbits',                        // Gigabits per second (DEC)
    TerabitPerSeconds::           'Tbits',                        // Terabits per second (DEC)
    PetabitsPerSeconds::          'Pbits',                        // Petabits per second (DEC)

    BytesPerSecond::              'binBps',                       // Bytes per second (IEC)
    KibibytesPerSecond::          'KiBs',                         // Kibibytes per second (IEC)
    MebibytesPerSeconds::         'MiBs',                         // Mebibytes per second (IEC)
    GigibytesPerSeconds::         'GiBs',                         // Gigibytes per second (IEC)
    TebibytesPerSeconds::         'TiBs',                         // Tebibytes per second (IEC)
    PebibytesPerSeconds::         'PiBs',                         // Pebibytes per second (IEC)

    BytesPerSecondDec::           'Bps',                          // Bytes per second (DEC)
    KilobytesPerSecond::          'KBs',                          // Kilobytes per second (DEC)
    MegabytesPerSeconds::         'MBs',                          // Megabytes per second (DEC)
    GigabytesPerSeconds::         'GBs',                          // Gigabytes per second (DEC)
    TerabytesPerSeconds::         'TBs',                          // Terabytes per second (DEC)
    PetabytesPerSeconds::         'PBs',                          // Petabytes per second (DEC)

    DateTimeIso::                 'dateTimeAsIso',                // Date and time in ISO format
    DateTimeIsoNoDateIfToday::    'dateTimeAsIsoNoDateIfToday',   // Date and time in ISO format, no date if today
    DateTimeUS::                  'dateTimeAsUS',                 // Date and time in US format
    DateTimeUSNoDateIfToday::     'dateTimeAsUSNoDateIfToday',    // Date and time in US format, no date if today
    dateTimeLocal::               'dateTimeAsLocal',              // Date and time in local format
    dateTimeLocalNoDateIfToday::  'dateTimeAsLocalNoDateIfToday', // Date and time in local format, no date if today

    Nanoseconds::                 'ns',                           // Nanoseconds
    Microseconds::                'µs',                           // Microseconds
    Milliseconds::                'ms',                           // Milliseconds
    Seconds::                     's',                            // Seconds
    Minutes::                     'm',                            // Minutes
    Hours::                       'h',                            // Hours
    Days::                        'd',                            // Days

    DurationMilliseconds::        'dtdurationms',                 // Duration in milliseconds
    DurationSeconds::             'dtdurations',                  // Duration in seconds
    DurationHMS::                 'dthms',                        // Duration (hh:mm:ss)
    DurationDHMS::                'dtdhms',                       // Duration (d hh:mm:ss)
    Timeticks::                   'timeticks',                    // Timeticks (s/100)
    ClockMilliseconds::           'clockms',                      // Clock in milliseconds
    ClockSeconds::                'clocks',                       // Clock in seconds

    HashesPerSecond::             'Hs',                           // Hashes per second
    KiloHashesPerSecond::         'KHs',                          // Kilo hashes per second
    MegaHashesPerSecond::         'MHs',                          // Mega hashes per second
    GigaHashesPerSecond::         'GHs',                          // Giga hashes per second
    TeraHashesPerSecond::         'THs',                          // Tera hashes per second
    PetaHashesPerSecond::         'PHs',                          // Peta hashes per second
    ExaHashesPerSecond::          'EHs',                          // Exa hashes per second

    CountsPerSecond::             'cps',                          // Counts per second
    OpsPerSecond::                'ops',                          // Operations per second
    RequestsPerSecond::           'reqps',                        // Requests per second
    ReadsPerSecond::              'rps',                          // Reads per second
    WritesPerSecond::             'wps',                          // Writes per second
    IOPerSeconds::                'iops',                         // I/O ops per second
    CountsPerMinute::             'cpm',                          // Counts per minute
    OpsPerMinute::                'opm',                          // Operations per minute
    ReadsPerMinute::              'rpm',                          // Reads per minute
    WritesPerMinute::             'wpm',                          // Writes per minute

    TrueFalse::                   'bool',                         // True / False
    YesNo::                       'bool_yes_no',                  // Yes / No
    OnOff::                       'bool_on_off',                  // On / Off
  }
}
