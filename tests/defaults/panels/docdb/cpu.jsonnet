local defaults = import '../../../../defaults.libsonnet';

{
  panel: defaults.panels.aws.docdb.cpu.panel(
    datasource    = 'datasource',
    namespace     = 'namespace',
    environment   = 'environment',
    notifications = ['notifications'],
    cluster_id    = 'cluster_id',
  ),
}
