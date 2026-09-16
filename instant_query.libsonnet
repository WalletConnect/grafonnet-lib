// Make an alert rule's query an INSTANT query instead of a range query.
//
// `alertRule.new` (alert_rule.libsonnet) always builds a RANGE query
// (`instant: false, range: true`), so Grafana re-evaluates the
// expression once per step across the whole lookback window — hundreds of steps,
// of which the `Last` reducer keeps exactly one. That waste is invisible for a
// `rate(x[5m])` expression and ruinous for a burn-rate expression carrying a
// multi-day range vector, where every step rescans days of samples for every
// series behind the SLI.
//
// Lives at the top level rather than under slo/ because it patches an `alertRule.new`
// result and is useful to any rule whose expression carries its own range vector.
//
// An instant query evaluates the expression once, at the evaluation timestamp,
// which is precisely what a rule that reduces with `Last` wants. `relativeTimeRange`
// is left alone (Grafana ignores `from` for an instant query, and keeping it
// matches how Grafana itself provisions instant alert queries), and only the query
// (`data[0]`) is touched — the reduce/threshold expressions (`data[1:]`) still
// work: reduce over a single-sample frame returns that sample.
function(rule) rule {
  data: [rule.data[0] { model+: { instant: true, range: false } }] + rule.data[1:],
}
