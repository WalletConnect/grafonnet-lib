local grafana         = import '../grafana.libsonnet';
local defaults        = import '../defaults/values.libsonnet';

{
  cpu(
    cfg,
    refid = defaults.refid.cpu,
  ):: cfg
    .addOverride(grafana.override.new(
      name = '%s_Max' % refid,
      properties = [{
        id: 'color',
        value: {
          mode:       'fixed',
          fixedColor: defaults.colors.cpu_alt
        }
      }],
    ))
    .addOverride(grafana.override.new(
      name = '%s_Avg' % refid,
      properties = [{
        id: 'color',
        value: {
          mode:       'fixed',
          fixedColor: defaults.colors.cpu
        }
      }],
    )),


  memory(
    cfg,
    refid = defaults.refid.mem
  ):: cfg
    .addOverride(grafana.override.new(
      name = '%s_Max' % refid,
      properties = [{
        id: 'color',
        value: {
          mode:       'fixed',
          fixedColor: defaults.colors.memory_alt
        }
      }],
    ))
    .addOverride(grafana.override.new(
      name = '%s_Avg' % refid,
      properties = [{
        id: 'color',
        value: {
          mode:       'fixed',
          fixedColor: defaults.colors.memory
        }
      }],
    )),


    cpu_memory(
      cfg,
      refid_cpu = defaults.refid.cpu,
      refid_mem = defaults.refid.mem,
    ):: $.memory($.cpu(cfg, refid_cpu), refid_mem),
}
