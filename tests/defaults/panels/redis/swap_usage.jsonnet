local defaults = import '../../../../defaults.libsonnet';

{
  panel: defaults.panels.aws.redis.swap_usage.panel(
    datasource    = 'datasource',
    namespace     = 'namespace',
    environment   = 'environment',
    notifications = ['notifications'],
    cluster_id    = 'cluster_id',
  ),
}
