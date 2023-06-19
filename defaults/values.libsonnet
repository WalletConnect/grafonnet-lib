local units = import '../utils/units.libsonnet';

{
  refid: {
    cpu: 'CPU',
    mem: 'Mem',
  },

  alerts: {
    priority:   null,
    timeStart:  '5m',
    period:     '5m',
    frequency:  '1m',

    mem: {
      limit:    70,   // 70%
      refid:    $.refid.mem,
      reducer:  'Avg',
    },
    cpu: {
      limit:    70,   // 70%
      refid:    $.refid.cpu,
      reducer:  'Avg',
    },
  },

  available_memory: {
    threshold:   4  * units.bin.GiB,
    capacity:   16  * units.bin.GiB,  // AWS DocDB max on db.r6g.large
  },

  resource: {
    thresholds: {
      warning:  40,   // 40%
      critical: 70,   // 70%
    },
  },

  colors: {
    cpu:        'blue',
    cpu_alt:    'dark-' + $.colors.cpu,

    memory:     'purple',
    memory_alt: 'dark-' + $.colors.memory,

    ok:         'green',
    warn:       'orange', // '#EAB839',
    critical:   'red',
  },
}
