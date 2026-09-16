/**
 * The two panels that make SLO ALERTING visible, as opposed to the objective.
 *
 * A compliance tile answers "are we meeting the promise" — it plots the indicator
 * against its objective. Neither tile answers "are we about to be paged", and the gap
 * between those questions is wide enough to mislead: a 95% objective grants a 5% error
 * budget, so the fast tier needs roughly 72% of requests failing, while an indicator
 * sitting at 94% compliance is missing its SLO and is about a twelfth of the way to
 * firing. Reading one number as if it were the other is wrong in both directions.
 *
 * So these plot what the rules actually evaluate (slo/burn_rate.libsonnet):
 *
 *   burn_rate         how fast the 30-day budget is being spent, as the same multiple
 *                     the tiers are named after — 14.4x / 6x / 1x drawn as lines.
 *   budget_remaining  how much of the 30-day budget is left per SLI, which is the
 *                     runway the multiple is spending.
 *
 * Both derive their arithmetic from burn_rate.libsonnet rather than restating it,
 * including the `monthly_events` projections that size the budget: a panel that
 * disagreed with the rule about the size of the budget would read healthy while the
 * alert fired. That agreement is pinned by slo/tests/budget_panels_test.yaml.
 *
 * USAGE
 *
 *   local sloPanels = import 'grafonnet-lib/slo/panels.libsonnet';
 *   sloPanels.burn_rate(ds, slis, { dimension_word: 'chain' })        { gridPos: ... },
 *   sloPanels.budget_remaining(ds, slis, { dimension_word: 'chain' }) { gridPos: ... },
 */
local grafana = import '../grafana.libsonnet';
local defaults = import '../defaults.libsonnet';
local defaultBurnRate = import 'burn_rate.libsonnet';

local panels = grafana.panels;
local targets = grafana.targets;

{
  defaults:: {
    /**
     * What one aggregation dimension is called, in prose ('chain', 'route', 'tenant').
     * Both panels reduce across dimensions to one series per SLI, so the legend needs to
     * say which dimension it kept.
     */
    dimension_word: 'dimension',
    /** Extra sentences appended to the burn-rate panel description. */
    extra_notes: [],
    /** See slo/rule.libsonnet — overridable so a retuned tier table moves the lines. */
    burn_rate: defaultBurnRate,
  },

  /**
   * Per-SLI reduction across aggregation dimensions.
   *
   * An SLI may aggregate `by (route)` / `by (chain_id)`, and the alert fires if ANY
   * dimension breaches, so the aggregate to display per SLI is the extreme across
   * dimensions — the one closest to alerting. `max` for burn, `min` for what is left.
   * Per-dimension detail belongs on a scorecard or a per-dimension row; putting
   * sixty-odd series on these two panels would bury the handful of numbers they exist
   * to show.
   *
   * The `or label_replace(vector(...))` tail supplies the healthy value when the SLI has
   * no series at all. That is not hypothetical: a well-written `bad()` counts failures
   * with no `or vector(0)` (see the note on `condition`), so on a clean hour the bad
   * count is genuinely EMPTY rather than zero, and without this the healthiest possible
   * state would render as a gap in the chart, indistinguishable from a broken query.
   */
  perSli(slis, aggregate, expr_for, healthy)::
    std.join('\n  or\n', [
      '(%s by (sli) (%s) or label_replace(vector(%d), "sli", "%s", "", ""))' % [
        aggregate,
        expr_for(sli),
        healthy,
        sli.key,
      ]
      for sli in slis
    ]),

  /**
   * The window to plot the burn over is the FAST tier's: the most urgent tier and the
   * shortest window that can trip it. The slower tiers are then readable off the same
   * series as "sustained above their line for their window", which is exactly what they
   * measure.
   */
  fastTier(burnRate)::
    local matches = [t for t in burnRate.tiers if t.key == 'fast'];
    assert std.length(matches) == 1 :
           'slo/panels.libsonnet: expected exactly one `fast` tier in burn_rate.libsonnet, found %d' % std.length(matches);
    matches[0],

  burn_rate(ds, slis, opts = {})::
    local o = $.defaults + opts;
    local burnRate = o.burn_rate;
    local burnTier = $.fastTier(burnRate);
    // One threshold line per tier, at the burn multiple that tier fires on, coloured by
    // its priority. Derived from the tier table, so retuning a tier moves the line with
    // the rule. Ascending by `burn`, which Grafana requires of threshold steps.
    local tierColor = { P0: 'red', P1: 'orange', P2: 'yellow', P3: 'yellow', P4: 'yellow' };
    local sorted = std.sort(burnRate.tiers, function(t) t.burn);
    local burnSteps = [{ color: tierColor[t.priority], value: t.burn } for t in sorted];
    local maxBurn = std.foldl(function(acc, t) std.max(acc, t.burn), burnRate.tiers, 0);
    panels.timeseries(
      title = 'SLO error budget burn rate (%s window)' % burnTier.long,
      description = std.join(' ', [
        'How fast each SLO is spending its 30-day error budget, as a multiple: 1x spends the whole budget in exactly 30 days, %gx in about 2 days.' % burnTier.burn,
        'Lines mark the alert tiers — %s.' % std.join(', ', ['%gx = %s' % [t.burn, t.priority] for t in sorted]),
        'Crossing a line is necessary but NOT sufficient to alert: the rule also requires the same burn over its short window and at least %d bad events.' % burnRate.min_bad_events,
        'Each series is the worst %s within that SLO; the alert instance names which one.' % o.dimension_word,
      ] + o.extra_notes),
      datasource = ds.prometheus,
    )
    .configure(
      defaults.configuration.timeseries
      .withUnit(grafana.fieldConfig.units.Short)
      .withThresholds('green', burnSteps)
      .withThresholdStyle('line')
      // Soft: a burn spike well past the top line still rescales, but an idle service
      // sitting at 0 should not hide the lines that give the axis its meaning.
      .withSoftLimit(axisSoftMin = 0, axisSoftMax = maxBurn + 1)
    )
    .addTarget(targets.prometheus(
      datasource = ds.prometheus,
      expr = $.perSli(slis, 'max', function(sli) burnRate.burn_multiple(sli, burnTier.long, burnTier.long_seconds), 0),
      exemplar = false,
      legendFormat = '{{sli}}',
      // A 10-minute step, pinned rather than left to Grafana's auto-interval. The budget
      // denominator is a 30-day `increase()` evaluated at EVERY step, so at the auto step
      // (roughly one point per pixel) a wide time range turns this panel into hundreds of
      // 30-day range queries over per-dimension series. The denominator is a monthly
      // estimate that cannot move meaningfully inside ten minutes, so the resolution
      // buys nothing.
      interval = '10m',
      refId = 'BurnRate',
    )),

  budget_remaining(ds, slis, opts = {}):: {
    local o = $.defaults + opts,
    type: 'bargauge',
    title: 'SLO error budget remaining (30d)',
    description: std.join(' ', [
      "Share of each SLO's 30-day error budget still unspent, worst %s per SLO." % o.dimension_word,
      'The budget is a COUNT of bad events — (1 - objective) x monthly events — so 100% is a clean month and 0% is exactly spent.',
      'NEGATIVE means the objective is being missed outright (the bar empties, the number keeps counting): -100% is twice the allowed bad events.',
      'Trailing 30 days, with no calendar reset — a budget refilling on the 1st would make the same incident urgent or ignorable depending on the date.',
    ]),
    datasource: ds.prometheus,
    options: {
      displayMode: 'gradient',
      orientation: 'horizontal',
      reduceOptions: { calcs: ['lastNotNull'], fields: '', values: false },
      showUnfilled: true,
      minVizHeight: 16,
      minVizWidth: 8,
      valueMode: 'color',
    },
    fieldConfig: {
      defaults: {
        unit: grafana.fieldConfig.units.Percent,
        // The bar is scaled 0-100; an over-spent budget reads as an empty bar with a
        // negative number next to it. Deliberately not clamped in the query — see
        // `budget_remaining_pct` — because "how far past the promise" is the useful part
        // of a blown budget, and it is the number, not the bar, that carries it.
        min: 0,
        max: 100,
        color: { mode: 'thresholds' },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            // Base red: at or below zero the objective is already missed.
            { color: 'red', value: null },
            { color: 'yellow', value: 0 },
            // A quarter of the month's budget left is the point at which the trend
            // matters more than the number; nothing alerts off this line.
            { color: 'green', value: 25 },
          ],
        },
        decimals: 1,
      },
      overrides: [],
    },
    targets: [
      targets.prometheus(
        datasource = ds.prometheus,
        expr = $.perSli(slis, 'min', function(sli) o.burn_rate.budget_remaining_pct(sli), 100),
        exemplar = false,
        legendFormat = '{{sli}}',
        // Instant: one evaluation of a 30-day window, not one per step. A range query
        // here would be the most expensive panel on the dashboard for a value whose
        // trajectory is already on the burn-rate chart next to it.
        instant = true,
        refId = 'BudgetRemaining',
      ),
    ],
  },
}
