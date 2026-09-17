/**
 * SLO burn-rate alert rules — the Grafana wrapper around slo/burn_rate.libsonnet.
 *
 * Grafana Unified Alerting (v10.4+).
 *
 * Produces ONE rule group per burn tier, each holding a single multi-dimensional rule
 * that unions every SLI opted into that tier. The tier owns its group name and its
 * evaluation interval; the mechanics, the tier table and the noise floor live in
 * burn_rate.libsonnet, and the indicators live in the consumer's own SLI table.
 *
 * Everything repo-specific is an `opts` field, because the two production consumers of
 * this file differed in exactly two things when it was extracted — the name of the label
 * carrying the priority, and two sentences of annotation prose. Those are parameters; the
 * rest is shared.
 *
 * USAGE
 *
 *   local sloRule = import 'grafonnet-lib/slo/rule.libsonnet';
 *   local slis    = import 'slis.libsonnet';
 *
 *   sloRule.ruleGroups(ds, folder_uid, slis, {
 *     name_prefix:    vars.envCapitalized,
 *     labels:         vars.labels,
 *     priority_label: 'og_priority',
 *     dimension_template: '{{ if $labels.chain_id }} on chain {{ $labels.chain_id }}{{ end }}',
 *     dashboard_hint: "then that chain's row under Chain RPC Router.",
 *   })
 *
 * The result is a list of rule groups, so a consumer aggregating groups from several
 * domains concatenates rather than appends:
 *
 *   rule_groups: [ appAlerts.ruleGroup(...), ... ] + sloRule.ruleGroups(...)
 *
 * Each group name must also appear wherever the consumer enumerates rule groups for
 * Terraform (they become `for_each` keys, so they cannot be derived from the render), or
 * the group is silently never provisioned.
 */
local alertRule = import '../alert_rule.libsonnet';
local instantQuery = import '../instant_query.libsonnet';
local defaultBurnRate = import 'burn_rate.libsonnet';

{
  /**
   * @param ds          object with a `prometheus_uid` field
   * @param folder_uid  Grafana folder to create the groups in
   * @param slis        list of SLIs (see the contract at the top of burn_rate.libsonnet)
   * @param opts        see `defaults` below
   */
  ruleGroups(ds, folder_uid, slis, opts = {})::
    local o = $.defaults + opts;
    local burnRate = o.burn_rate;

    // Group names must be unique or two tiers would write to the same Grafana group and
    // the later one would silently replace the earlier. jsonnet is lazy, so this has to
    // sit somewhere that is always evaluated — the comprehension below references it.
    local uniqueGroups =
      local names = [t.group for t in burnRate.tiers];
      assert std.length(std.set(names)) == std.length(names) :
             'slo/rule.libsonnet: burn-rate tiers must have distinct `group` names, got %s' % [names];
      true;

    assert uniqueGroups;
    [
      alertRule.ruleGroup(
        name = t.group,
        folder_uid = folder_uid,
        interval_seconds = t.interval_seconds,
        rules = [$.rule(ds, folder_uid, slis, t, o)],
      )
      for t in burnRate.tiers
    ],

  /** One tier's rule. Exposed for consumers that assemble groups themselves. */
  rule(ds, folder_uid, slis, tier, opts = {})::
    local o = $.defaults + opts;
    local burnRate = o.burn_rate;
    // Instant, not range: the burn windows live inside the expression, so evaluating it
    // once per rule run is all the `Last` reducer can use. See instant_query.
    instantQuery(alertRule.prometheus(
      name = '%s - SLO %s' % [o.name_prefix, tier.name],
      folder_uid = folder_uid,
      rule_group = tier.group,
      datasource_uid = ds.prometheus_uid,
      expr = burnRate.expr(slis, tier),
      // The threshold is inside the expr (a series exists only while breaching), so the
      // rule only has to notice that a series appeared. The query is instant, so `Last`
      // reduces a single sample per series.
      condition = alertRule.reducers.Last,
      threshold = 0,
      op = alertRule.operators.GreaterThan,
      // One evaluation interval — see the `for_duration` note on burnRate.tiers.
      for_duration = tier.for_duration,
      labels = o.labels + {
        [o.priority_label]: tier.priority,
        // Ride into the notification so an alert can be read without opening Grafana,
        // and so routing can tell the tiers apart without parsing the rule name.
        burn_rate: '%g' % tier.burn,
        long_window: tier.long,
      },
      annotations = {
        // `$value` is the condition's value, which is the percent of the 30-day budget
        // spent inside the long window — see burnRate.condition.
        // WHAT and WHERE first, in both fields. A notification is usually read as a
        // one-line title on a phone, so the burning dimension has to survive
        // truncation — `dimension_template` puts it immediately after the SLI name
        // rather than in a sentence two thirds of the way down.
        // Shaped to stand alone as a NOTIFICATION TITLE, which is why it repeats the
        // tier name already in the rule name: a contact point templated on
        // `.CommonAnnotations.summary` renders this and nothing else, so it has to carry
        // tier, indicator and dimension by itself. Numbers come last — they are the part
        // a truncated title can afford to lose.
        summary: '%(prefix)s - SLO %(tier)s: {{ $labels.sli }}%(dim)s — {{ printf "%%.1f" $value }}%% of 30-day budget in %(long)s (limit %(long_pct)s%%)' % {
          prefix: o.name_prefix,
          tier: tier.name,
          dim: o.dimension_template,
          long: tier.long,
          long_pct: burnRate.budget_pct(tier, tier.long_seconds),
        },
        description: (
          '{{ $labels.sli }}%(dim)s burned {{ printf "%%.1f" $value }}%% of its 30-day error ' +
          'budget in the last %(long)s, and is still burning as of the last %(short)s. ' +
          'Tier limit is %(long_pct)s%% per %(long)s — %(burn)gx the sustainable pace, which ' +
          'exhausts the month in %(exhaust)s. Objective: {{ $labels.objective }}.%(hint)s ' +
          'Budget alert, not an outage: a 5-minute chart can look healthy while the month is ' +
          'still being missed. Dashboard: SLIs row at %(long)s, %(dashboard_hint)s'
        ) % {
          dim: o.dimension_template,
          long: tier.long,
          short: tier.short,
          burn: tier.burn,
          long_pct: burnRate.budget_pct(tier, tier.long_seconds),
          exhaust: $.exhaustText(tier),
          hint: if o.dimension_hint == '' then '' else ' ' + o.dimension_hint,
          dashboard_hint: o.dashboard_hint,
        },
      },
      no_data_state = alertRule.noDataStates.OK,
    )),

  /**
   * How long the whole 30-day budget lasts at this tier's burn rate — the concrete
   * consequence behind an abstract percentage, so the alert says "gone in ~2.1 days"
   * rather than only "2% per hour".
   */
  exhaustText(tier)::
    local days = 30 / tier.burn;
    if days == std.floor(days) then '%d days' % days else '~%.1f days' % days,

  defaults:: {
    /** Environment prefix on the rule name, e.g. 'Prod'. */
    name_prefix: '',
    /** Base labels merged onto every rule (environment, team, service, ...). */
    labels: {},
    /**
     * Which label carries the tier's priority. Grafana has no opinion; the routing
     * integration does, and the two repos this was extracted from disagreed
     * (`priority` vs `og_priority`), which is why this is a parameter and not a
     * constant.
     */
    priority_label: 'priority',
    /**
     * Names the burning dimension INLINE, right after the SLI, in both the summary and
     * the description. Go template, evaluated by Grafana against the alert instance, so
     * it must be guarded for SLIs that do not carry the label:
     *
     *     dimension_template: '{{ if $labels.chain_id }} on chain {{ $labels.chain_id }}{{ end }}'
     *
     * This exists because prose could not do the job. The previous version said "any
     * chain_id label on this instance names the chain that is burning" — which is a
     * description of where to find the answer rather than the answer, buried mid
     * paragraph, in an alert whose whole purpose is to say WHICH of sixty-nine chains
     * is burning. A notification is read as a one-line title first; the dimension has
     * to be in that line.
     *
     * Leading space is the caller's, since only they know whether the text reads as a
     * clause or a suffix.
     */
    dimension_template: '',
    /**
     * Optional extra sentence about which labels pinpoint what is burning, appended
     * after the objective. Superseded by `dimension_template` for the common case and
     * empty by default; kept because a consumer with several aggregation labels may
     * still want to explain them, and because it was the only mechanism before.
     */
    dimension_hint: '',
    /** How the description's closing "check the dashboard" sentence ends. */
    dashboard_hint: 'then the per-dimension panel for that indicator.',
    /**
     * The burn_rate module. Overridable so a consumer can retune the tier table
     * (`defaultBurnRate + { tiers:: [...] }`) without forking this file, and so the
     * tests can inject fixtures.
     */
    burn_rate: defaultBurnRate,
  },
}
