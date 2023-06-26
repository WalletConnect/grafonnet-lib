local defaults = import '../../../../defaults.libsonnet';

{
  panel: defaults.panels.aws.docdb.volume.panel(
    datasource    = 'datasource',
    cluster_id    = 'cluster_id',
  ),
}
