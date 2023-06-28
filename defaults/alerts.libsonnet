local grafana         = import '../grafana.libsonnet';
local strings         = import '../utils/strings.libsonnet';
local units           = import '../utils/units.libsonnet';
local values          = import '../defaults/values.libsonnet';

local panels = grafana.panels;

local alert_name(target, name, env, title) =
  if name != null then name else "%(env)s - %(title)s - %(target)s Utilization alert" % {
    target: target,
    env:    strings.capitalize(env),
    title:  title
  };
local alert_message(target, message, env, title, limit) =
  if message != null then message else '%(env)s - %(title)s - %(target)s utilization is high (over %(limit)d%%)'  % {
    target: target,
    env:    strings.capitalize(env),
    title:  title,
    limit:  limit,
  };

{
  memory(
    namespace,
    env,
    title,
    name          = null,
    message       = null,
    notifications = [],
    priority      = null,
    refid         = values.alerts.mem.refid,
    limit         = values.alerts.mem.limit,
    reducer       = values.alerts.mem.reducer,
    timeStart     = values.alerts.timeStart,
    period        = values.alerts.period,
    frequency     = values.alerts.frequency,
  ):: grafana.alert.new(
    namespace     = namespace,
    name          = if name != null then name else "%(env)s - %(title)s - Memory Utilization alert" % {
                      env:    strings.capitalize(env),
                      title:  title
                    },
    message       = if message != null then message else '%(env)s - %(title)s - Memory utilization is high (over %(limit)d%%)' % {
                      env:    strings.capitalize(env),
                      title:  title,
                      limit:  limit,
                    },
    period        = period,
    frequency     = frequency,
    notifications = notifications,
    alertRuleTags = [if priority != null then { og_priority: priority } else {}],
    conditions    = [ $.conditions.memory(limit, timeStart, reducer, refid) ],
  ),


  cpu(
    namespace,
    env,
    title,
    name          = null,
    message       = null,
    notifications = [],
    priority      = null,
    refid         = values.alerts.cpu.refid,
    limit         = values.alerts.cpu.limit,
    reducer       = values.alerts.cpu.reducer,
    timeStart     = values.alerts.timeStart,
    period        = values.alerts.period,
    frequency     = values.alerts.frequency,
  ):: grafana.alert.new(
    namespace     = namespace,
    name          = if name != null then name else "%(env)s - %(title)s - CPU Utilization alert" % {
                      env:    strings.capitalize(env),
                      title:  title
                    },
    message       = if message != null then message else '%(env)s - %(title)s - CPU utilization is high (over %(limit)d%%)' % {
                      env:    strings.capitalize(env),
                      title:  title,
                      limit:  limit,
                    },
    period        = period,
    frequency     = frequency,
    notifications = notifications,
    alertRuleTags = [if priority != null then { og_priority: priority } else {}],
    conditions    = [ $.conditions.cpu(limit, timeStart, reducer, refid) ],
  ),


  cpu_mem(
    namespace,
    env,
    title,
    name          = null,
    message       = null,
    notifications = [],
    priority      = null,
    period        = values.alerts.period,
    frequency     = values.alerts.frequency,

    cpu           = {
      refid         : values.alerts.cpu.refid,
      limit         : values.alerts.cpu.limit,
      reducer       : values.alerts.cpu.reducer,
      timeStart     : values.alerts.timeStart,
    },
    memory        = {
      refid         : values.alerts.mem.refid,
      limit         : values.alerts.mem.limit,
      reducer       : values.alerts.mem.reducer,
      timeStart     : values.alerts.timeStart,
    },
  ):: grafana.alert.new(
    namespace     = namespace,
    name          = if name != null then name else "%(env)s - %(title)s - CPU / Memory Utilization alert" % {
                      env:    strings.capitalize(env),
                      title:  title
                    },
    message       = if message != null then message else '%(env)s - %(title)s - CPU / Memory utilization is high (over %(cpu_limit)d%% CPU or %(mem_limit)d%% Memory)' % {
                      env:    strings.capitalize(env),
                      title:  title,
                      cpu_limit:  cpu.limit,
                      mem_limit:  memory.limit,
                    },
    period        = period,
    frequency     = frequency,
    notifications = notifications,
    alertRuleTags = [if priority != null then { og_priority: priority } else {}],
    conditions    = [
      $.conditions.cpu(
        cpu.limit,
        cpu.timeStart,
        cpu.reducer,
        cpu.refid
      ),
      $.conditions.memory(
        memory.limit,
        memory.timeStart,
        memory.reducer,
        memory.refid
      ),
    ],
  ),


  //////////////////////////////////////////////////////////////////////////////
  // Alert conditions

  conditions:: {
    cpu(
      limit         = values.alerts.limit,
      timeStart     = values.alerts.timeStart,
      reducer       = values.alerts.reducer,
      refid         = values.refid.CPU,
    ):: grafana.alertCondition.new(
      evaluatorParams = [ limit ],
      evaluatorType   = grafana.alertCondition.evaluators.Above,
      operatorType    = grafana.alertCondition.operators.And,
      queryRefId      = '%s_%s' % [refid, strings.capitalize(reducer)],
      queryTimeStart  = timeStart,
      queryTimeEnd    = 'now',
      reducerType     = reducer,
    ),

    memory(
      limit         = values.alerts.limit,
      timeStart     = values.alerts.timeStart,
      reducer       = values.alerts.reducer,
      refid         = values.refid.Memory,
    ):: grafana.alertCondition.new(
      evaluatorParams = [ limit ],
      evaluatorType   = grafana.alertCondition.evaluators.Above,
      operatorType    = grafana.alertCondition.operators.And,
      queryRefId      = '%s_%s' % [refid, strings.capitalize(reducer)],
      queryTimeStart  = timeStart,
      queryTimeEnd    = 'now',
      reducerType     = reducer,
    ),
  },
}
