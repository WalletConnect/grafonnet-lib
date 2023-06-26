local grafana         = import '../../grafonnet-lib/grafana.libsonnet';
local defaults        = import '../../grafonnet-lib/defaults.libsonnet';
local targets         = import 'targets.libsonnet';

{
  aws:: {
    amqp:: {
      available_messages::      import 'panels/aws/amqp/available_messages.libsonnet',
      cpu::                     import 'panels/aws/amqp/cpu.libsonnet',
      in_flight_messages::      import 'panels/aws/amqp/in_flight_messages.libsonnet',
      memory::                  import 'panels/aws/amqp/memory.libsonnet',
      storage::                 import 'panels/aws/amqp/storage.libsonnet',
    },
    docdb:: {
      available_memory::        import 'panels/aws/docdb/available_memory.libsonnet',
      buffer_cache_hit_ratio::  import 'panels/aws/docdb/buffer_cache_hit_ratio.libsonnet',
      connections::             import 'panels/aws/docdb/connections.libsonnet',
      cpu::                     import 'panels/aws/docdb/cpu.libsonnet',
      low_mem_op_throttled::    import 'panels/aws/docdb/low_mem_op_throttled.libsonnet',
      net_throughput::          import 'panels/aws/docdb/net_throughput.libsonnet',
      volume::                  import 'panels/aws/docdb/volume.libsonnet',
      write_latency::           import 'panels/aws/docdb/write_latency.libsonnet',
    },
    ecs:: {
      cpu::                     import 'panels/aws/ecs/cpu.libsonnet',
      memory::                  import 'panels/aws/ecs/memory.libsonnet',
      cpu_memory::              import 'panels/aws/ecs/cpu_memory.libsonnet',
    },
    redis:: {
      cpu::                     import 'panels/aws/redis/cpu.libsonnet',
      memory::                  import 'panels/aws/redis/memory.libsonnet',
      swap_usage::              import 'panels/aws/redis/swap_usage.libsonnet',
    }
  }
}
