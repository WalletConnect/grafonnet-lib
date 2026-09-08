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
 *     dimension_hint: 'Any chain_id label on this instance names the chain that is burning.',
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
        summary: '%s - SLO {{ $labels.sli }} has spent {{ $value }}%% of its 30-day error budget in %s' % [
          o.name_prefix,
          tier.long,
        ],
        description: (
          'SLO {{ $labels.sli }} (objective: {{ $labels.objective }}) spent {{ $value }}%% of its ' +
          '30-day error budget in the last %(long)s, and is still over-spending as of the last ' +
          '%(short)s. The limit for this tier is %(long_pct)s%% per %(long)s (%(burn)gx the ' +
          'sustainable pace); at that rate the whole month of budget is gone in %(exhaust)s. ' +
          '%(dimension_hint)s ' +
          'This is a budget alert, not an outage alert: the SLI may look fine on a 5-minute chart ' +
          'and still be on track to miss the objective. Check the SLIs row of the dashboard with ' +
          'the range set to %(long)s, %(dashboard_hint)s'
        ) % {
          long: tier.long,
          short: tier.short,
          burn: tier.burn,
          long_pct: burnRate.budget_pct(tier, tier.long_seconds),
          exhaust: $.exhaustText(tier),
          dimension_hint: o.dimension_hint,
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
     * One sentence naming the label(s) that pinpoint what is burning, so an on-call
     * reading the alert knows which dimension to look at. Aggregation labels are the
     * SLI's business, so the wrapper cannot infer this.
     */
    dimension_hint: 'Any aggregation label on this instance names the dimension that is burning.',
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
