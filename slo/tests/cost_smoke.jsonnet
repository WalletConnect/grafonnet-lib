// Renders the cost burn-rate group (slo/cost.libsonnet) against a $720/month budget —
// $1 per hour at the sustainable pace, so every allowance below is readable by eye —
// and pins what promtool cannot see: these rules are CloudWatch queries plus Grafana
// expressions, not PromQL.
local cost = import '../cost.libsonnet';

local group = cost.ruleGroup({
  budget_usd: 720,
  datasource_uid: 'cw',
  folder_uid: 'folder',
  name_prefix: 'Prod',
  labels: { environment: 'prod' },
  priority_label: 'og_priority',
});

local byName = { [r.name]: r for r in group.rules };
local ref(rule, id) = [d for d in rule.data if d.refId == id][0];
local fast = byName['Prod - Cost fast burn'];
local budget = byName['Prod - Cost over budget'];
local stale = byName['Prod - Cost data missing'];

// Allowance = budget x burn x window / 720h. Fast: 720 x 3 x 24/720 = $72 long, $18 short.
assert ref(fast, 'C').model.expression == '$LS > 72.000000 && $SS > 18.000000' : ref(fast, 'C').model.expression;
// Budget tier is the sustainable pace itself: 168h at $1/h.
assert ref(budget, 'C').model.expression == '$LS > 168.000000 && $SS > 24.000000' : ref(budget, 'C').model.expression;

// Windows end `settle_hours` back and cover exactly the tier's hours of settled data.
assert ref(fast, 'L').relativeTimeRange == { from: (14 + 24) * 3600, to: 14 * 3600 };
assert ref(fast, 'S').relativeTimeRange == { from: (14 + 6) * 3600, to: 14 * 3600 };

// Each hour is read at its Maximum: the poller re-writes revised hours, and Sum would
// count every revision. Metric-search mode, because Metrics Insights (SQL) cannot
// reach a window that starts 14h+ back.
assert std.all([
  d.model.statistic == 'Maximum' && d.model.period == '3600' && d.model.metricQueryType == 0
  for r in group.rules
  for d in r.data
  if d.datasourceUid == 'cw'
]);

// Nothing pages, the priority lands on the consumer's label, and a broken poller is
// loud while a quiet window is not.
assert std.all([r.labels.og_priority != 'P0' && r.labels.og_priority != 'P1' for r in group.rules]);
assert fast.no_data_state == 'OK' && stale.no_data_state == 'Alerting';

// The spend lands in the notification title.
assert std.length(std.findSubstr('$values.LS', fast.annotations.summary)) == 1;

assert std.length(group.rules) == 4;
group
