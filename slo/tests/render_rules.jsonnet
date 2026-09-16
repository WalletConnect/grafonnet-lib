// Renders the SLO alerting expressions as Prometheus rules files so promtool can
// evaluate them against synthetic timeseries.
//
// Every expression is pulled from the shipping library, not restated, so a case cannot
// pass by agreeing with a copy of the mistake. What this deliberately does NOT reproduce
// is the Grafana wrapper — folder, datasource, reduce/threshold expressions, labels —
// none of which Prometheus understands. The `for` mirrors each rule's.
//
// The SLIs are FIXTURES (fixtures.libsonnet), not any consumer's real indicators. This
// library owns the mechanics; whether a given repo's objective is the right number is
// that repo's business and belongs in that repo's tests.
//
// THREE output files, because promtool re-evaluates every group in its `rule_files` at
// every step of every test case. Keeping the 6h/3d tiers out of the short-window suite
// stops the fast cases paying for windows they do not exercise.
//
// Rendered with `jsonnet -S -m` — multi-file output, and -S so the already-JSON string
// values are written raw rather than re-encoded. promtool reads JSON as YAML.
local burnRate = import '../burn_rate.libsonnet';
local fixtures = import 'fixtures.libsonnet';

local slis = fixtures.slis;

local group(tier) = {
  name: 'slo-burn-rate-%s' % tier.key,
  // Production cadence, from the tier itself, so the rendered rules match what ships.
  // This does NOT drive promtool's cost — that follows each test file's
  // `evaluation_interval`, which the group interval does not override.
  interval: '%ds' % tier.interval_seconds,
  rules: [{
    alert: 'SLO_%s' % tier.key,
    expr: burnRate.expr(slis, tier),
    'for': tier.for_duration,
  }],
};

// The identity the burn-rate panel rests on, and the only reason drawing a line at
// `tier.burn` means anything: the panel's multiple exceeds a tier's burn factor exactly
// when that tier's LONG-WINDOW clause is over its budget share. The panel is derived
// from the condition by dividing both sides by `w/30d * 100` (`burn_multiple`) — get
// that factor wrong and the chart draws its tier lines in the wrong place, which is not
// falsifiable by eye.
//
// Only the long clause is compared: the alert also requires its short window and the
// bad-event floor, so a crossing is deliberately NOT equivalent to an alert firing.
local probe = fixtures.budgetProbe;
local panelGroup(tier) = {
  name: 'slo-panel-identity-%s' % tier.key,
  interval: '%ds' % tier.interval_seconds,
  rules: [
    {
      alert: 'PANEL_BURN_%s' % tier.key,
      expr: '%s > %s' % [burnRate.burn_multiple(probe, tier.long, tier.long_seconds), tier.burn],
    },
    {
      alert: 'LONG_CLAUSE_%s' % tier.key,
      expr: '100 * %s / %s > %s' % [
        burnRate.bad_count(probe, tier.long),
        burnRate.budget_events(probe),
        burnRate.budget_pct(tier, tier.long_seconds),
      ],
    },
    // Pinned by MAGNITUDE rather than by sign. Sign alone is too weak: it survives the
    // numerator and denominator spanning different windows. Shrink
    // `budget_remaining_pct`'s numerator from 30d to 1h and a sign-only case still
    // passes while the panel reads ~100% remaining forever — "runway full" while the
    // alert fires, the worst reading this panel could give.
    {
      alert: 'PANEL_REMAINING_AT_ZERO_%s' % tier.key,
      expr: 'abs(%s) < 10' % burnRate.budget_remaining_pct(probe),
    },
    {
      alert: 'PANEL_REMAINING_AT_MINUS_100_%s' % tier.key,
      expr: 'abs(%s + 100) < 10' % burnRate.budget_remaining_pct(probe),
    },
  ],
};

local manifest(groups) = std.manifestJsonEx({ groups: groups }, '  ');

{
  'rules_fast.generated.json': manifest([group(t) for t in burnRate.tiers if t.key == 'fast']),
  'rules_all.generated.json': manifest([group(t) for t in burnRate.tiers]),
  // Fast tier only: the identity is algebraic and window-independent, so evaluating it
  // at three windows would pay the 3d window's cost to re-test the same division.
  'panel_rules.generated.json': manifest([panelGroup(t) for t in burnRate.tiers if t.key == 'fast']),
}
