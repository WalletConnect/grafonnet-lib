// SLI fixtures for the library's own tests.
//
// Deliberately synthetic and deliberately NOT any consumer's real indicators: these
// exercise the MECHANICS (windows, budget sizing, the noise floor, expression splicing),
// which is what this library owns. Whether a given repo's objective is the right number
// is that repo's business and belongs in that repo's tests.
{
  // Two plain counters at 99%, aggregated service-wide. The simplest shape.
  local plain = {
    key: 'plain',
    objective: 0.99,
    objective_text: '99% of requests succeed',
    bad(w):: 'sum(increase(fixture_bad_total[%s]))' % w,
    events(w):: 'sum(increase(fixture_total[%s]))' % w,
  },

  // The same, split by a dimension, so the sparse-denominator and per-dimension paths
  // are covered.
  //
  // `events` is a TAGGED UNION, and both obvious alternatives are broken. `sum(good) +
  // sum(bad)` yields NOTHING when either side has no series — which is the state of a
  // dimension in total outage, since a process only exports a counter's label set once
  // something increments it — so the budget comes back empty and the alert cannot fire
  // during a 100% failure. A single selector matching both metrics by `__name__` is
  // worse: `increase()` drops `__name__`, so the two collapse to the same label set and
  // Prometheus rejects the vector outright unless some OTHER label happens to
  // distinguish them. That "happens to" is load-bearing and invisible; this fixture
  // deliberately gives `good` and `bad` IDENTICAL label sets so the suite fails if
  // anyone reaches for it.
  //
  // Tagging each side makes `or` a genuine union rather than a filter, and `sum by
  // (route)` then drops the tag — the same idiom `burn_rate.max_of` uses.
  local tagged(metric, tag, w) =
    'label_replace(increase(%s[%s]), "__part__", "%s", "", "")' % [metric, w, tag],
  local byRoute = {
    key: 'by-route',
    objective: 0.99,
    objective_text: '99% of requests succeed, per route',
    bad(w):: 'sum by (route) (increase(fixture_route_bad_total[%s]))' % w,
    events(w):: 'sum by (route) (%s or %s)' % [
      tagged('fixture_route_good_total', 'good', w),
      tagged('fixture_route_bad_total', 'bad', w),
    ],
  },

  // A deliberately LOOSE objective: 75% clears only the 1x tier, so it must declare
  // `tiers` explicitly or the feasibility assert in burn_rate.condition fires.
  local lenient = {
    key: 'lenient',
    objective: 0.75,
    objective_text: '75% of requests succeed (best effort)',
    tiers: ['budget'],
    bad(w):: 'sum by (route) (increase(fixture_lenient_bad_total[%s]))' % w,
    events(w):: 'sum by (route) (%s or %s)' % [
      tagged('fixture_lenient_good_total', 'good', w),
      tagged('fixture_lenient_bad_total', 'bad', w),
    ],
  },

  // An UNPARENTHESISED compound `bad()`, which is the shape `burn_rate.bad_count` exists
  // to wrap. Spliced bare into `100 * %s / %s` it parses as `(100 * sum(a)) - (sum(b) /
  // budget)` — not a ratio, but a number in the millions, so the tier fires permanently
  // for every SLI in the rule. No real SLI is written this way, so nothing else pins it.
  local splice = {
    key: 'splice-probe',
    objective: 0.99,
    objective_text: 'test fixture for the bad() splice',
    bad(w):: 'sum(increase(splice_total[%(w)s])) - sum(increase(splice_good_total[%(w)s]))' % { w: w },
    events(w):: 'sum(increase(splice_total[%s]))' % w,
  },

  // Tuned so the month's budget is a round number for the panel-identity tests:
  // 12/min projects to 518,400 monthly events, and a 1% budget is exactly 5,184.
  local budgetProbe = {
    key: 'budget-probe',
    objective: 0.99,
    objective_text: 'test fixture for the budget panels',
    bad(w):: 'sum(increase(budget_probe_bad_total[%s]))' % w,
    events(w):: 'sum(increase(budget_probe_total[%s]))' % w,
  },

  plain:: plain,
  byRoute:: byRoute,
  lenient:: lenient,
  splice:: splice,
  budgetProbe:: budgetProbe,
  slis:: [plain, byRoute, lenient, splice],
}
