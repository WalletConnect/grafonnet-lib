local defaults = import '../../../../defaults.libsonnet';

{
  panel: defaults.panels.aws.docdb.net_throughput.panel(
    datasource    = 'datasource',
    cluster_id    = 'cluster_id',
  ),
}
