local defaults = import '../../../../defaults.libsonnet';

{
  panel: defaults.panels.aws.ecs.cpu_memory.panel(
    datasource    = 'datasource',
    namespace     = 'namespace',
    environment   = 'environment',
    notifications = ['notifications'],
    service_name  = 'service_name',
  ),
}
