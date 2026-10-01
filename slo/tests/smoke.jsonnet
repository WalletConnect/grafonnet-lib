// Renders the rule groups and both panels from fixture SLIs, which is where every
// assert in burn_rate.libsonnet fires, and then guards the two properties of the
// rendered ALERT that no other test in this directory can see.
//
// promtool evaluates PromQL, so burn_rate_test.yaml and friends cover the expressions
// and nothing else. The annotation templates and the rule's failure states are Grafana
// concerns; they render here or they are unchecked, and both of the things guarded
// below shipped to production once already.
local sloRule = import '../rule.libsonnet';
local sloPanels = import '../panels.libsonnet';
local fixtures = import 'fixtures.libsonnet';
local ds = { prometheus: { type: 'prometheus', uid: 'p' }, prometheus_uid: 'p' };

local groups = sloRule.ruleGroups(ds, 'folder', fixtures.slis, {
  name_prefix: 'Prod',
  labels: { environment: 'prod' },
  priority_label: 'og_priority',
  dimension_template: '{{ if $labels.route }} on route {{ $labels.route }}{{ end }}',
  dashboard_hint: 'then the per-route panel.',
});

local rules = std.flattenArrays([g.rules for g in groups]);
local annotations = std.flattenArrays([[r.annotations.summary, r.annotations.description] for r in rules]);

// In Grafana alerting `$value` is a STRING — the rendering of every captured value,
// `[ var='B' labels={...} value=12.3 ]` — so a float verb applied to it produces
// `%!f(string=...)`, or `%!f(string=)` when nothing was captured. The float lives at
// `$values.<refId>.Value`; see the `budgetPct` note in rule.libsonnet.
//
// Counted rather than pattern-matched, so the guard holds whatever the prose around it
// becomes and whatever verb a future edit reaches for: every `$value` in a rendered
// annotation has to be the prefix of a `$values`.
local noBareValue(s) =
  std.length(std.findSubstr('$value', s)) == std.length(std.findSubstr('$values', s));

assert std.all([noBareValue(a) for a in annotations]) :
       'slo/rule.libsonnet: annotation uses a bare `$value`, which is a string in ' +
       'Grafana and renders as %!f(string=...) under a float verb. Use ' +
       '`$values.<refId>.Value` — see `budgetPct`.';

// A 30-day budget rule that could not evaluate has said nothing about the budget.
// Leaving this at the library default (`Error`) makes Grafana raise a DatasourceError
// carrying these annotations, i.e. page the service on-call with every field empty.
assert std.all([r.exec_err_state == 'OK' for r in rules]) :
       'slo/rule.libsonnet: burn-rate rules must not alert on evaluation errors; ' +
       'monitor rule health via grafana_alerting_rule_evaluation_failures_total instead.';

{
  groups: groups,
  burn_panel: sloPanels.burn_rate(ds, fixtures.slis, { dimension_word: 'route' }),
  budget_panel: sloPanels.budget_remaining(ds, fixtures.slis, { dimension_word: 'route' }),
}
