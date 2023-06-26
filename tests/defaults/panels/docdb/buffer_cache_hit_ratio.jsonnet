local defaults = import '../../../../defaults.libsonnet';

{
  panel: defaults.panels.aws.docdb.buffer_cache_hit_ratio.panel(
    datasource    = 'datasource',
    cluster_id    = 'cluster_id',
  ),
}
