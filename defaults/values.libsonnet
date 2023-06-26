local grafana = import '../grafana.libsonnet';
local units   = import '../utils/units.libsonnet';

{
  refid:: {
    cpu::         'CPU',
    mem::         'Mem',
  },

  alerts:: {
    priority::    null,
    timeStart::   '5m',
    period::      '5m',
    frequency::   '1m',

    mem:: {
      limit::     70,   // 70%
      refid::     $.refid.mem,
      reducer::   grafana.alertCondition.reducers.Avg,
    },
    cpu:: {
      limit::     70,   // 70%
      refid::     $.refid.cpu,
      reducer::   grafana.alertCondition.reducers.Avg,
    },
  },

  available_memory:: {
    threshold::   units.size_bin(GiB =  4),
    capacity::    units.size_bin(GiB = 16),   // AWS DocDB max on db.r6g.large
  },

  resource:: {
    thresholds:: {
      warning::   40,   // 40%
      critical::  70,   // 70%
    },
  },

  colors:: {
    cpu::         'blue',
    cpu_alt::     'dark-' + $.colors.cpu,

    memory::      'purple',
    memory_alt::  'dark-' + $.colors.memory,

    ok::          'green',
    warn::        'orange', // '#EAB839',
    critical::    'red',
  },

  priorities:: {
    Critical::      'P1',
    High::          'P2',
    Moderate::      'P3',
    Low::           'P4',
    Informational:: 'P5',
  },
}
