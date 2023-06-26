local defaults = import '../../../../defaults.libsonnet';

{
  panel: defaults.panels.aws.docdb.connections.panel(
    datasource    = 'datasource',
    cluster_id    = 'cluster_id',
  ),
}
