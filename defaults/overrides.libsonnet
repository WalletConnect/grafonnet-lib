local grafana         = import '../grafana.libsonnet';
local defaults        = import '../defaults/values.libsonnet';

{
  cpu(cfg, refid = defaults.refid.cpu):: cfg
    .addOverride(grafana.override.newColorOverride(
      name = '%s_Avg' % refid,
      color = defaults.colors.cpu
    ))
    .addOverride(grafana.override.newColorOverride(
      name = '%s_Max' % refid,
      color = defaults.colors.cpu_alt
    )),


  memory(cfg, refid = defaults.refid.mem):: cfg
    .addOverride(grafana.override.newColorOverride(
      name = '%s_Avg' % refid,
      color = defaults.colors.memory
    ))
    .addOverride(grafana.override.newColorOverride(
      name = '%s_Max' % refid,
      color = defaults.colors.memory_alt
    )),

  cpu_memory(cfg, refid = defaults.refid.cpu, refid_mem = defaults.refid.mem):: cfg
    .addOverride(grafana.override.newColorOverride(
      name = '%s_Avg' % refid,
      color = defaults.colors.cpu
    ))
    .addOverride(grafana.override.newColorOverride(
      name = '%s_Max' % refid,
      color = defaults.colors.cpu_alt
    ))
    .addOverride(grafana.override.newColorOverride(
      name = '%s_Avg' % refid,
      color = defaults.colors.memory
    ))
    .addOverride(grafana.override.newColorOverride(
      name = '%s_Max' % refid,
      color = defaults.colors.memory_alt
    )),
}
