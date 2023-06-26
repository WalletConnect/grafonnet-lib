local defaults = import '../../../../defaults.libsonnet';

{
  panel: defaults.panels.aws.docdb.low_mem_op_throttled.panel(
    datasource    = 'datasource',
    namespace     = 'namespace',
    environment   = 'environment',
    notifications = ['notifications'],
    cluster_id    = 'cluster_id',
  ),
}
