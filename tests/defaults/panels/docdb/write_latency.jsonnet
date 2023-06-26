local defaults = import '../../../../defaults.libsonnet';

{
  panel: defaults.panels.aws.docdb.write_latency.panel(
    datasource    = 'datasource',
    cluster_id    = 'cluster_id',
  ),
}
