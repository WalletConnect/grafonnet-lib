local defaults = import '../../defaults.libsonnet';

{
  memory: defaults.alerts.memory(
    namespace     = 'monitoring',
    env           = 'production',
    title         = 'Memory usage alert',
    notifications = ['slack'],
    priority      = defaults.values.priorities.Critical,
  ),

  cpu: defaults.alerts.cpu(
    namespace     = 'monitoring',
    env           = 'production',
    title         = 'CPU usage alert',
    notifications = ['slack'],
    priority      = defaults.values.priorities.Critical,
  ),

  cpu_mem: defaults.alerts.cpu_mem(
    namespace     = 'monitoring',
    env           = 'production',
    title         = 'CPU and memory usage alert',
    notifications = ['slack'],
    priority      = defaults.values.priorities.Critical,
  ),
}
