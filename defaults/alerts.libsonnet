local grafana         = import '../grafana.libsonnet';
local strings         = import '../utils/strings.libsonnet';
local units           = import '../utils/units.libsonnet';
local defaults        = import '../defaults/values.libsonnet';

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
    refid         = defaults.alerts.mem.refid,
    limit         = defaults.alerts.mem.limit,
    reducer       = defaults.alerts.mem.reducer,
    timeStart     = defaults.alerts.timeStart,
    period        = defaults.alerts.period,
    frequency     = defaults.alerts.frequency,
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
    refid         = defaults.alerts.cpu.refid,
    limit         = defaults.alerts.cpu.limit,
    reducer       = defaults.alerts.cpu.reducer,
    timeStart     = defaults.alerts.timeStart,
    period        = defaults.alerts.period,
    frequency     = defaults.alerts.frequency,
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
    period        = defaults.alerts.period,
    frequency     = defaults.alerts.frequency,

    cpu           = {
      refid         : defaults.alerts.cpu.refid,
      limit         : defaults.alerts.cpu.limit,
      reducer       : defaults.alerts.cpu.reducer,
      timeStart     : defaults.alerts.timeStart,
    },
    memory        = {
      refid         : defaults.alerts.mem.refid,
      limit         : defaults.alerts.mem.limit,
      reducer       : defaults.alerts.mem.reducer,
      timeStart     : defaults.alerts.timeStart,
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
      $.conditions.cpu(cpu.limit, cpu.timeStart, cpu.reducer, cpu.refid),
      $.conditions.memory(memory.limit, memory.timeStart, memory.reducer, memory.refid),
    ],
  ),

  available_memory(
    namespace,
    env,
    title         = 'DocumentDB',
    name          = null,
    message       = null,
    notifications = [],
    priority      = null,
    mem_threshold = defaults.available_memory.threshold,
    timeStart     = defaults.alerts.timeStart,
    period        = defaults.alerts.period,
    frequency     = defaults.alerts.frequency,
    reducer       = defaults.alerts.mem.reducer,
    refid         = 'Mem',
  ):: grafana.alert.new(
    namespace     = namespace,
    name          = if name != null then name else "%(env)s - %(title)s - Available Memory alert" % {
                      env:    strings.capitalize(env),
                      title:  title
                    },
    message       = if message != null then message else '%(env)s - %(title)s - Available Memory is low (under %(threshold)s)' % {
                      env:    strings.capitalize(env),
                      title:  title,
                      threshold:  strings.sizeof_fmt(mem_threshold),
                    },
    period        = period,
    frequency     = frequency,
    notifications = notifications,
    alertRuleTags = [if priority != null then { og_priority: priority } else {}],
    conditions    = [ $.conditions.available_memory(mem_threshold, timeStart, reducer, refid) ],
  ),

  test: $.available_memory(
    namespace     = 'TEST_NS',
    title         = 'DocumentDB',
    env           = 'staging',
    notifications = ['Notif1'],
    priority      = 'P2',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Alert conditions

  conditions:: {
    cpu(
      limit         = defaults.alerts.limit,
      timeStart     = defaults.alerts.timeStart,
      reducer       = defaults.alerts.reducer,
      refid         = 'CPU',
    ):: grafana.alertCondition.new(
      evaluatorParams = [ limit ],
      evaluatorType   = 'gt',
      operatorType    = 'and',
      queryRefId      = '%s_%s' % [refid, reducer],
      queryTimeStart  = timeStart,
      queryTimeEnd    = 'now',
      reducerType     = std.asciiLower(reducer),
    ),

    memory(
      limit         = defaults.alerts.limit,
      timeStart     = '5m',
      reducer       = 'Avg',
      refid         = 'Mem',
    ):: grafana.alertCondition.new(
      evaluatorParams = [ limit ],
      evaluatorType   = 'gt',
      operatorType    = 'and',
      queryRefId      = '%s_%s' % [refid, reducer],
      queryTimeStart  = timeStart,
      queryTimeEnd    = 'now',
      reducerType     = std.asciiLower(reducer),
    ),

    available_memory(
      mem_threshold = defaults.alerts.available_memory_threshold,
      timeStart     = '5m',
      reducer       = 'Avg',
      refid         = 'Mem',
    ):: grafana.alertCondition.new(
      evaluatorParams = [ mem_threshold ],
      evaluatorType   = 'lt',
      operatorType    = 'and',
      queryRefId      = '%s_%s' % [refid, reducer],
      queryTimeStart  = timeStart,
      queryTimeEnd    = 'now',
      reducerType     = std.asciiLower(reducer),
    ),
  },
}
