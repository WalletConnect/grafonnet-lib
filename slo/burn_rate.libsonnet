{
  /**
   * Multiwindow, multi-burn-rate SLO alerting — approach 6 from the Google SRE
   * Workbook chapter "Alerting on SLOs"
   * (https://sre.google/workbook/alerting-on-slos/).
   *
   * WHY, versus a threshold alert. "availability < 95% for 5m" (the workbook's approach
   * 3) flaps for a structural reason rather than a tuning one: a threshold on a short
   * window says nothing about whether the objective is actually at risk, so a single bad
   * minute and a month of sustained breach look identical to it, and the only tuning
   * knobs available (raise the threshold, lengthen the `for:`) trade the noise away for
   * blindness to real degradation. A burn-rate alert measures how fast the 30-day error
   * budget is being spent, so urgency tracks consequence — and the same three rules
   * cover every SLO instead of one hand-tuned threshold per metric.
   *
   * WHAT IS MEASURED: the share of the 30-day error budget spent inside the window.
   * The budget is a COUNT — `(1 - objective) x monthly events` — so the condition is
   * `bad_events(window) / budget_events > percent`, counts over counts.
   *
   * This needs every objective to be a RATIO of good events, which is how the SLOs in
   * an SLO catalog should state them. An objective stated as a percentile would give
   * nothing to count and therefore no budget to spend.
   *
   * The workbook writes this as a rate instead: `(bad/valid) / (1-objective) > burn`,
   * where 14.4x means "spending 2% of the month's budget in an hour". The two agree
   * exactly when the window's traffic is a proportional slice of the month, which is
   * the case the workbook is written for and is often NOT the case for a
   * multi-dimensional SLI. Whenever per-dimension volume spans orders of magnitude — a
   * busy production route and an idle testnet as two dimensions of one SLI — a short
   * window on a quiet dimension is routinely unrepresentative, and the rate form then
   * misstates budget consumption in BOTH directions: 2-of-2 failures on a dimension that
   * normally serves thousands of requests an hour reads as a 20x burn while consuming a
   * negligible slice of the budget, and the same 2-of-2 on a dimension that really does
   * serve 2 requests an hour is a large fraction of its budget and a correct alert.
   * Counting against the budget cannot confuse those, and needs no floor on traffic to
   * avoid it. The tiers keep the workbook's 14.4x / 6x / 1x names, since the percentages
   * are derived from them.
   *
   * WHY TWO WINDOWS. A long window alone resets slowly — after a short spike it
   * keeps firing for the remainder of the window. Requiring the same burn rate
   * over a short window (long / 12) as well makes the alert clear within minutes
   * of the burn stopping, which is also why these rules need no long `for:`
   * debounce: the short window IS the debounce.
   *
   * LOW TRAFFIC. Counting against the month's budget removes most of what the
   * workbook's "Low-traffic services and error budget alerting" section warns about —
   * a quiet window can no longer inflate a burn, because the denominator does not come
   * from the window. What remains is that a tight objective makes the budget itself
   * small, so on a low-volume dimension an hour's share at the fast tier can be less
   * than one request, and a single failure is not evidence of anything. Hence one floor,
   * on the number of BAD events (`min_bad_events`). Note what it is NOT: a floor on
   * traffic. Gating on request volume would suppress a total outage on a quiet dimension
   * just as effectively as it suppresses noise — the mistake documented on
   * `min_bad_events`.
   */

  /**
   * An SLI, as consumed by `condition` / `expr`:
   *
   *   key         Short slug; lands on the alert instance as the `sli` label and
   *               is what the on-call reads first.
   *   objective   Required good-event ratio, as a number (0.99 = 99%). The
   *               error budget is `1 - objective`.
   *   objective_text  The objective in words ("99% of RPC requests served"), so an
   *               alert never shows a burn rate without saying what it is burning.
   *   bad(w)      PromQL for the bad-event COUNT over window `w`.
   *   events(w)   PromQL for the total event COUNT over `w`; used to size the 30-day
   *               budget. Must aggregate identically to `bad` (same `by` labels).
   *   tiers       OPTIONAL list of tier keys this SLI is alerted on; every tier by
   *               default. See `tiers_for` — a loose objective is mathematically
   *               unable to trip the faster tiers, so it must opt out explicitly
   *               rather than be dropped silently.
   */

  // The recommended tiers from the workbook's table for a 30-day budget, with
  // short = long / 12.
  //
  // PRIORITY IS A FUNCTION OF HOW SOON THE OBJECTIVE BREAKS, NOT OF WHICH SLI IS
  // BURNING. That is the whole reason severity can live on the tier rather than on the
  // indicator, and it is worth being explicit because it inverts the intuition every
  // threshold alert in this repo is built on.
  //
  // At 14.4x the entire month's budget is gone in ~2.1 days, so the objective breaks
  // this week unless someone intervenes now: P0. At 6x there are ~5 days of runway,
  // which is a fix-within-24-hours problem rather than a wake-someone-up one: P1. At 1x
  // the budget lasts exactly the 30 days it is meant to, so there is no deadline and no
  // discrete event to respond to — the objective is simply being missed, which is
  // information, not an incident: P3, visibility only.
  //
  // What this deliberately does NOT do is grade by importance of the SLI. A best-effort
  // testnet burning at 14.4x and a flagship production chain burning at 14.4x are the
  // same alert at the same priority, because each is measured against its OWN objective
  // and each is therefore the same number of days from breaking a promise that was made.
  // Something nobody cares much about is expressed as a LOOSER OBJECTIVE (so it takes far
  // more to burn at all — see `tier_feasible`), never as a lower priority on the same
  // burn rate. Grading by importance would double-count: the objective already encodes it.
  //
  // OVERRIDE, don't fork. These are hidden (`::`) fields, so a consumer that needs a
  // different ladder writes `burnRate + { tiers:: [...] }` rather than copying the file.
  // Adopting this in a repo whose alerting tops out below P0 is a real change to who
  // gets woken — intended, since a 2-day-to-breach burn is genuinely urgent, but worth
  // deciding rather than inheriting.
  //
  // `for_duration` is deliberately one evaluation interval, not a debounce: the
  // short window already is the debounce, and a longer `for` would only delay a
  // detection the windows have smoothed. It has to be a whole multiple of
  // `interval_seconds` or Grafana rejects the group — asserted below.
  //
  // `interval_seconds` is the group's evaluation interval, and lives here rather than
  // in the rule builder (slo/rule.libsonnet) so the rendered rules and the promtool harness
  // (terraform/monitoring/tests/) agree on the cadence production uses, and so
  // `for_duration` can be checked against it (below).
  //
  // `group` is the Grafana rule group each tier gets — one tier per group, deliberately.
  // Amazon Managed Grafana's `PutAlertRuleGroup` becomes unreliable past ~10 rules in a
  // group and the payload has a size ceiling, and one of these multi-dimensional rules
  // is several KB on its own. Consumers that enumerate rule groups statically in
  // Terraform (because the names become `for_each` keys) must list all three, or the
  // missing group is silently never provisioned.
  tiers:: [
    {
      key: 'fast',
      group: 'SLO Fast Burn',
      name: 'fast burn',
      burn: 14.4,
      long: '1h',
      short: '5m',
      long_seconds: 3600,
      short_seconds: 300,
      priority: 'P0',
      interval_seconds: 60,
      for_duration: '1m',
    },
    {
      key: 'slow',
      group: 'SLO Slow Burn',
      name: 'slow burn',
      burn: 6,
      long: '6h',
      short: '30m',
      long_seconds: 21600,
      short_seconds: 1800,
      priority: 'P1',
      interval_seconds: 60,
      for_duration: '1m',
    },
    {
      key: 'budget',
      group: 'SLO Error Budget',
      name: 'error budget depleting',
      burn: 1,
      long: '3d',
      short: '6h',
      long_seconds: 259200,
      short_seconds: 21600,
      // A 3d window cannot meaningfully move inside 10 minutes, and evaluating it
      // every 60s is a lot of Prometheus work for nothing.
      interval_seconds: 600,
      priority: 'P3',
      for_duration: '10m',
    },
  ],

  // NOISE FLOOR: the minimum number of BAD events before a burn is believed.
  //
  // It exists for one narrow reason. A tight objective on a low-volume dimension makes
  // the budget itself small: 99% of a dimension serving 720 requests a month is a budget
  // of about 7 failures, so the fast tier's 2%-per-hour allowance is a fraction of one
  // request — and a single error is not evidence of anything. Two is.
  //
  // The floor guards BAD events, never traffic. Gating on request VOLUME instead would
  // suppress by volume rather than by evidence: any threshold high enough to quiet a
  // stray failure on the busiest dimension would disarm the rule entirely on every
  // low-volume one, silencing a 100%-failure outage exactly as thoroughly as one stray
  // error. There is deliberately no floor on VALID events either: the budget is a finite
  // NUMBER of bad events, and for a low-volume dimension that number is small, so a
  // couple of bad events genuinely is a large fraction of it. Requiring the dimension to
  // be busy first suppresses precisely the real burns this is for.
  //
  // Counting against the budget is what lets the floor stay this small. The rate form
  // `(bad/valid)/(1-objective)` needs a much heavier guard, because it divides by the
  // WINDOW's traffic: 2 bad of 2 on a normally-busy dimension reads as a 20x burn while
  // consuming almost none of the month's budget. Dividing by the month's traffic
  // instead cannot make that mistake, so nothing beyond the floor is needed.
  //
  // 2 is the smallest floor that is strictly more than a single event, not a measured
  // optimum. Measured on one production service over 30 days it was the binding clause
  // for a 99.99% availability objective and never bound for 95%-objective indicators,
  // whose budgets are thousands of events; raising it to 3 changed nothing and 5 or 10
  // only trimmed genuine incidents. Overridable (`burnRate + { min_bad_events:: 3 }`),
  // but if the fast tier is noisy on a specific SLI, read the burn-rate panel before
  // reaching for this: a floor is the wrong lever for an objective that is simply too
  // tight.
  min_bad_events:: 2,


  /**
   * Render a small positive decimal for PromQL: plain fixed point, no float
   * noise, no scientific notation.
   *
   * Neither jsonnet formatter is usable here. '%s' % (1 - 0.95) gives
   * "0.050000000000000003", and '%g' % (1 - 0.9999) gives "10e-05" — which
   * Prometheus does parse as 1e-4, but nobody reading the rule should have to
   * check that. Fixed point plus trimming gives "0.05" and "0.0001".
   */
  decimal(x)::
    local s = '%.10f' % x;
    local trimmed = std.rstripChars(s, '0');
    local out = if std.endsWith(trimmed, '.') then std.rstripChars(trimmed, '.') else trimmed;
    // An objective tighter than 10 decimal places (>= 0.99999999999) rounds to "0"
    // here, and `RATIO / 0 > 14.4` is +Inf > 14.4 — an alert that fires permanently
    // rather than one that fails loudly. Unreachable at any objective we would
    // write, which is exactly why it needs to be an assert and not a comment.
    assert out != '0' && out != '' :
           'burn_rate.decimal: %s is too small to render at 10 decimal places; the budget would emit "%s" and the burn comparison would divide by zero' % [x, out];
    out,

  /**
   * Element-wise maximum of vectors that may be SPARSE — i.e. a label set present in
   * one input and missing from another. PromQL has no element-wise max operator
   * (`max()` aggregates across series), and the usual `(a > b) or b` idiom is wrong
   * here: `>` is a filtering match, so a label set missing from `b` is dropped by
   * `a > b` and `or b` has nothing to restore it with. Folded over three windows the
   * result collapses to only the label sets present in the SPARSEST input.
   *
   * That is not hypothetical — it shipped in the first draft of this file and was caught
   * by backtesting against production. `max_of([30d, 1d*30, 1h*720])`
   * over per-chain counters yielded a denominator for only the chains exporting samples
   * in the last hour; chains with a month of data each got nothing, because the 1h term
   * is the sparsest and the fold made it decide which label sets survived.
   *
   * The exposure is any SLI that splits `by (...)` over dimensions with a long quiet
   * tail — per-chain, per-route, per-tenant. A counter's series stops being scraped when
   * its label set stops being exported (after a deploy, say, for a dimension that has
   * since seen no requests), which is the normal state for such a tail and invisible in
   * the alert.
   *
   * Only the BUDGET tier could actually be disarmed by it — the bug needs a dimension
   * inside the short window but outside the 1h estimate, and only that tier's 6h short
   * window is longer than an hour. Still a silent disarm, which is the worst failure
   * mode available to an alert, so it is pinned by a test
   * (slo/tests/tier_windows_test.yaml) rather than only fixed:
   *
   * Tag each input with a synthetic label so `or` genuinely unions them (rather than
   * only filling in absent label sets), then aggregate that label away with `max`.
   * Missing inputs are simply absent from the aggregation instead of erasing the
   * group, every input is evaluated exactly once (the fold evaluated some twice), and
   * the caller's own labels come through untouched because `without` names only the
   * synthetic one — so this needs no knowledge of how the SLI aggregates.
   */
  max_of(estimates)::
    local tag = '__estimate__';
    'max without (%s) (%s)' % [
      tag,
      std.join(' or ', [
        'label_replace(%s, "%s", "%s", "", "")' % [e.expr, tag, e.name]
        for e in estimates
      ]),
    ],

  /**
   * Estimated events in a 30-day month, which is what the error budget is a fraction
   * of. `increase(m[30d])` alone is wrong for a young series: Prometheus caps
   * back-extrapolation at half a sample interval, so a metric with one day of history
   * returns one day of events and the budget reads 30x too small — an alert that
   * over-fires on arrival.
   *
   * That is a routine state, not an edge case: adding a dimension to a `by (...)` SLI —
   * a new chain, route or tenant — starts that dimension's counters from zero on the day
   * it ships.
   *
   * Taking the largest of three projections fixes it without special-casing: the 30d
   * count itself, one day scaled up, and one hour scaled up. Whichever window actually
   * has data wins, so a series older than an hour is estimated correctly. Erring
   * toward the LARGEST estimate errs toward a bigger budget and a less trigger-happy
   * alert, which is the safe direction.
   *
   * The three do NOT closely agree on real traffic, and are not meant to — traffic is
   * bursty and per-chain volume trends over a month. That is the reason the 30d term
   * stays in the list rather than being dropped as redundant: it is the accurate one
   * whenever it has data, and the short projections exist only to cover the
   * young-series case where it does not.
   */
  monthly_events(sli):: $.max_of([
    { name: '30d', expr: sli.events('30d') },
    { name: '1d', expr: '(%s) * 30' % sli.events('1d') },
    { name: '1h', expr: '(%s) * 720' % sli.events('1h') },
  ]),

  /**
   * Percent of the 30-day error budget a window is allowed to spend at this tier's
   * burn rate — the tier's headline number in the units the alert actually compares
   * (14.4x over 1h = 2% of the month's budget). Public so the annotations quote the
   * same arithmetic the condition uses rather than a hand-copied constant.
   */
  budget_pct(tier, window_seconds):: $.decimal(tier.burn * window_seconds / (30 * 86400) * 100),

  /**
   * The error budget itself, as a COUNT of bad events allowed per 30 days:
   * `(1 - objective) x monthly events`.
   *
   * Public so the budget panels (slo/panels.libsonnet) divide by the same
   * denominator the rules do, `monthly_events` projections and all. A chart that
   * sized the budget differently from the alert would be worse than no chart —
   * it would read as healthy while the on-call disagreed, and the projections are
   * exactly where the two could plausibly drift.
   */
  budget_events(sli):: '(%s * %s)' % [$.decimal(1 - sli.objective), $.monthly_events(sli)],

  /**
   * An SLI's bad-event count over `window`, PARENTHESISED.
   *
   * The parens are not cosmetic and are the reason this is a function rather than a
   * bare `sli.bad(w)` at each call site: `bad()` may be a compound expression, and
   * spliced bare into `100 * %s / %s` the expression `sum(a) - sum(b)` parses as
   * `(100 * sum(a)) - (sum(b) / budget)` — not a ratio at all, but a large positive
   * number that exceeds any threshold, so the tier fires permanently at every
   * objective. Invisible in the SLI definition, so it is wrapped here rather than left
   * to each author to remember, and pinned by the `splice_probe` case in
   * slo/tests/burn_rate_test.yaml.
   */
  bad_count(sli, window):: '(%s)' % sli.bad(window),

  /**
   * Tag a series with the SLI it came from: `sli` is what the on-call reads first and
   * what a panel legend groups by, and `objective` travels with it so a burn rate is
   * never displayed without saying what it is burning.
   */
  labelled(sli, expr)::
    'label_replace(label_replace(%s, "sli", "%s", "", ""), "objective", "%s", "", "")' % [
      expr,
      sli.key,
      sli.objective_text,
    ],

  /**
   * The burn rate as a MULTIPLE of nominal budget spend, which is the number the
   * tiers are named after: 1x spends the 30-day budget in exactly 30 days, 14.4x in
   * ~2 days. Directly comparable to `tier.burn`, so a panel can draw one line per
   * tier and a reader can see how close to alerting an SLI is.
   *
   * Derived from `condition`, not invented alongside it. That condition is
   *
   *     100 * bad(w) / budget > burn * w/30d * 100
   *
   * so dividing both sides by `w/30d * 100` gives the multiple this returns:
   *
   *     bad(w) / budget * 30d/w > burn
   *
   * Note what that means for reading a chart of this: the value crossing `tier.burn`
   * is only the FIRST of the tier's three clauses. An alert also needs the same burn
   * over the tier's short window and at least `min_bad_events` bad events, so a
   * crossing is necessary but not sufficient — deliberately, since those clauses are
   * what keep a single stray event off the alert.
   *
   * Labelled, and per-dimension: an SLI aggregating `by (route)` yields one series per
   * route, each against that route's own budget. Aggregating those for display
   * (`max by (sli)`) is the panel's business, not this file's.
   */
  burn_multiple(sli, window, window_seconds):: $.labelled(sli, '%s / %s * %s' % [
    $.bad_count(sli, window),
    $.budget_events(sli),
    $.decimal(30 * 86400 / window_seconds),
  ]),

  /**
   * Percent of the 30-day error budget still unspent: 100% is a clean month, 0% is
   * exactly spent, and NEGATIVE is over-spent — which is a real reading, not a defect
   * to clamp away. A panel showing this should let it go below zero.
   *
   * The trailing 30 days, so it matches the budget window the tiers are derived
   * from; there is no calendar-month reset, and none is wanted — a budget that
   * refills on the 1st would make the same incident urgent or ignorable depending
   * on the date.
   *
   * One asymmetry to know about: the numerator is the ACTUAL 30-day bad count while
   * the denominator may be a projection from a shorter window on a young series (see
   * `monthly_events`). That errs toward a larger budget, hence more apparent
   * remaining — the same safe direction the alert errs in.
   */
  budget_remaining_pct(sli):: $.labelled(sli, '100 - 100 * %s / %s' % [
    $.bad_count(sli, '30d'),
    $.budget_events(sli),
  ]),

  /**
   * Whether `tier` is mathematically capable of firing for `sli`'s objective.
   *
   * The window length cancels out of both of the condition's ratio clauses —
   * numerator and threshold scale with it alike — so at 100% failure the condition
   * reduces to `bad_fraction > burn * (1 - objective)`. Once that product reaches 1
   * the tier is asking for more than a total outage, and can never fire.
   *
   * The intuition: an hour is 1/720 of a month, so the most budget one hour can
   * consume is (1/720) / (1 - objective). A LOOSE objective has a huge budget, and an
   * hour is not enough of the month to spend the tier's share of it. Floors: 93.06%
   * for 14.4x, 83.33% for 6x, any objective for 1x. Tighter objectives are
   * progressively easier to fire, not harder.
   *
   * This is the workbook's own caveat, stated there for a 90% target: "Because a 100%
   * outage consumes only 1.4% of the budget in that hour, this alert could never fire."
   *
   * It is load-bearing rather than theoretical. A deliberately lenient objective — 75%
   * for something whose availability was never promised — clears only the 1x tier. That
   * is the correct outcome (what you did not promise to keep up should not produce an
   * urgent alert), but it MUST be declared rather than discovered: see `tiers_for`.
   */
  tier_feasible(sli, tier):: (1 - sli.objective) * tier.burn < 1,

  /**
   * The tiers an SLI is alerted on: its own `tiers` list if it declares one, every
   * tier otherwise.
   *
   * Opting out is EXPLICIT, and that is the whole point of this function. Deriving the
   * list from `tier_feasible` alone would be one line shorter and would quietly accept
   * the single most damaging typo available in slis.libsonnet: `0.993` mistyped as
   * `0.93` renders, deploys, looks healthy in config and silently has no fast tier.
   * Requiring the author to name the tiers means that typo instead trips the assert
   * below — an alert that is absent is worse than an alert that is wrong, because
   * nothing about it is visible until the incident it was supposed to catch.
   */
  tiers_for(sli)::
    local declared = if std.objectHas(sli, 'tiers') then sli.tiers else [t.key for t in $.tiers];
    local known = [t.key for t in $.tiers];
    assert std.length(declared) > 0 :
           'burn_rate.tiers_for: SLI %s declares no tiers, so nothing alerts on it at all. Delete the SLI or give it a tier.' % sli.key;
    assert std.length([k for k in declared if !std.member(known, k)]) == 0 :
           'burn_rate.tiers_for: SLI %s names unknown tier(s) %s; known tiers are %s.' % [sli.key, declared, known];
    declared,

  /** Whether this SLI participates in this tier. */
  covers(sli, tier):: std.member($.tiers_for(sli), tier.key),

  /**
   * One SLI's condition for one tier: a series that exists only while the SLI is
   * over-spending, valued at the PERCENT of its 30-day error budget consumed inside
   * the long window (so `{{ $value }}` reads "4.3" = 4.3% of the month's budget spent
   * in this window).
   *
   * Three clauses, all `and`-ed:
   *   1. budget spent over the LONG window exceeds the tier's share
   *   2. same over the SHORT window, so the alert clears promptly (see above)
   *   3. at least `min_bad_events` bad events — the noise floor
   *
   * The `>` comparisons are what keep these rules off Grafana's alert-instance quota
   * (AMG counts FIRING INSTANCES, not provisioned rules): a healthy SLI yields no series
   * at all, so it costs nothing. That matters most for a widely-fanned SLI — emit a
   * series per dimension unconditionally and the instance count sits in the dozens at
   * all times.
   *
   * A window with no bad events yields no series, so an idle dimension raises nothing
   * without needing an explicit denominator guard.
   *
   * `bad` and `events` must aggregate identically (same `by` labels) — they are
   * divided and `and`-ed, so a mismatch silently drops every series.
   */
  condition(sli, tier)::
    // Grafana rejects a rule group whose `for` is not a whole multiple of its
    // evaluation interval, and that failure only surfaces at apply time. Checked
    // here rather than as a standalone field because jsonnet is lazy: a hidden
    // field nothing references is never evaluated, so the check would be dead.
    local for_secs =
      if std.endsWith(tier.for_duration, 'm')
      then std.parseInt(std.substr(tier.for_duration, 0, std.length(tier.for_duration) - 1)) * 60
      else error 'burn_rate tier %s: for_duration must be whole minutes, got %s' % [tier.key, tier.for_duration];
    assert for_secs % tier.interval_seconds == 0 :
           'burn_rate tier %s: for_duration %s is not a whole multiple of its %ds evaluation interval' % [tier.key, tier.for_duration, tier.interval_seconds];
    assert $.tier_feasible(sli, tier) :
           'burn_rate: SLI %s objective %g is too loose for the %gx %s tier — even a 100%% failure spends only %.4g%% of the 30-day budget against this tier\'s %s%% threshold, so it can never fire. Either tighten the objective above 1 - 1/%g (~%.6g), or drop "%s" from that SLI\'s `tiers` list so the omission is on the page instead of in the arithmetic.' % [
             sli.key,
             sli.objective,
             tier.burn,
             tier.key,
             100 * tier.long_seconds / (30 * 86400) / (1 - sli.objective),
             $.budget_pct(tier, tier.long_seconds),
             tier.burn,
             1 - 1 / tier.burn,
             tier.key,
           ];
    local pct(window_seconds) = $.budget_pct(tier, window_seconds);
    local budget = $.budget_events(sli);
    local bad(w) = $.bad_count(sli, w);
    local labelled(expr) = $.labelled(sli, expr);
    labelled(std.join('\n', [
      '(',
      '    100 * %s / %s > %s' % [bad(tier.long), budget, pct(tier.long_seconds)],
      '  and',
      '    100 * %s / %s > %s' % [bad(tier.short), budget, pct(tier.short_seconds)],
      '  and',
      '    %s >= %d' % [bad(tier.long), $.min_bad_events],
      '  )',
    ])),

  /**
   * The whole tier as ONE multi-dimensional rule: every participating SLI's condition
   * unioned with `or`, told apart by the `sli` label.
   *
   * One rule per SLI would be the obvious shape and is the wrong one — Amazon Managed
   * Grafana's rule-group writes become unreliable past ~10 rules in a group. It is also
   * why a widely-fanned indicator should be ONE SLI aggregating `by (...)` rather than
   * one SLI per dimension: 60-odd dimensions x 3 tiers is not a shape AMG will accept.
   * Nothing is lost, because Grafana still emits one instance per breaching dimension,
   * so the annotations name exactly which one is burning.
   *
   * Consequence to keep in mind: labels — including the priority label — are per RULE,
   * so every SLI in a tier shares that tier's priority. Burn-rate alerting wants that
   * (severity comes from how fast the budget is going, not from which SLO), but an SLI
   * needing its own priority needs its own rule.
   */
  expr(slis, tier)::
    local covered = [sli for sli in slis if $.covers(sli, tier)];
    assert std.length(covered) > 0 :
           'burn_rate.expr: no SLI participates in the %s tier, so its rule would render an empty expression. Remove the tier from `tiers` or give an SLI that opts into it.' % tier.key;
    std.join('\n  or\n', [$.condition(sli, tier) for sli in covered]),
}
