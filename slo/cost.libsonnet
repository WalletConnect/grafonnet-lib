{
  /**
   * Multiwindow, multi-burn-rate alerting on a service's WHOLE AWS bill against a
   * monthly budget in dollars — the SLO burn-rate idea (burn_rate.libsonnet) applied to
   * spend instead of bad events.
   *
   * WHY ACCOUNT TOTAL, not per usage type. A regression arrives on whichever line it
   * arrives on — AMP query samples one month, Cognito token requests the next — and a
   * rule per line only catches the lines someone thought to watch. The account total
   * catches all of them; which line moved is a Cost Explorer question once it fires.
   *
   * THE INPUT is one CloudWatch metric holding the account's cost per billed hour, one
   * datapoint per hour, timestamped at the start of that hour. Cost Explorer is the
   * only source of the total, so a small poller writes it (pay-core's
   * terraform/cost-reporter is the reference). The poller re-writes recent hours as
   * Cost Explorer revises them, so every query here reads each hour's MAXIMUM —
   * a revision only ever adds charges, and a duplicate datapoint must not count twice.
   *
   * SETTLE OFFSET. Cost Explorer's hourly data lands ~10h late and the newest hours
   * fill in over several more, so a window ending "now" reads its last hours as
   * near-zero and UNDER-states the burn — a silent miss, never a false page. Every
   * window therefore ends `settle_hours` ago and covers settled hours only. That offset
   * is also the floor on detection: nothing here can fire sooner than ~a day after a
   * regression starts, which is the price of watching the whole bill rather than one
   * live usage metric.
   *
   * THE TIERS are the SLO tiers' shape retuned for spend. The SLO ladder (14.4x / 6x)
   * is built for outages; a cost regression is rarely that steep — pay-core's AMP bill
   * went to 1.8x a sensible budget, then 3.3x, over two months, and would have tripped
   * neither. Each tier compares spend over a long window against the share of the
   * month's budget that window is allowed at `burn` times the sustainable pace, and
   * requires the same over a short window so the alert clears soon after spend drops
   * back. Nothing pages: overspend is never a 3am problem.
   */
  tiers:: [
    { key: 'fast', name: 'fast burn', burn: 3, long_hours: 24, short_hours: 6, priority: 'P2' },
    { key: 'slow', name: 'slow burn', burn: 1.5, long_hours: 72, short_hours: 12, priority: 'P3' },
    { key: 'budget', name: 'over budget', burn: 1, long_hours: 168, short_hours: 24, priority: 'P3' },
  ],

  // Measured on pay-core prod (2026-10-07): the newest hour with any cost was ~10h old
  // and hours younger than ~13h were still partial. 14 leaves an hour of margin.
  settle_hours:: 14,

  // The input changes once an hour, so evaluating more often only re-reads it.
  interval_seconds:: 900,

  // A month is 30 days here, as in burn_rate.libsonnet.
  month_hours:: 720,

  /** Dollars a window may spend at a tier's burn multiple. */
  allowance(budget_usd, burn, hours):: budget_usd * burn * hours / $.month_hours,

  // A CloudWatch metric query over [now - settle - hours, now - settle], one point per
  // hour at the hour's Maximum. Metric-search mode, not SQL: Metrics Insights only
  // reaches back three hours, and every window here starts further back than that.
  local query(ref, opts, hours) = {
    refId: ref,
    queryType: '',
    relativeTimeRange: {
      from: ($.settle_hours + hours) * 3600,
      to: $.settle_hours * 3600,
    },
    datasourceUid: opts.datasource_uid,
    model: {
      refId: ref,
      datasource: { type: 'cloudwatch', uid: opts.datasource_uid },
      queryMode: 'Metrics',
      metricQueryType: 0,
      metricEditorMode: 0,
      region: 'default',
      namespace: opts.namespace,
      metricName: opts.metric_name,
      dimensions: {},
      matchExact: true,
      statistic: 'Maximum',
      period: '3600',
      id: '',
      expression: '',
    },
  },

  local expression(ref, model) = {
    refId: ref,
    queryType: '',
    relativeTimeRange: { from: 0, to: 0 },
    datasourceUid: '__expr__',
    model: { refId: ref, datasource: { type: '__expr__', uid: '__expr__' } } + model,
  },

  local sum(ref, of) = expression(ref, {
    type: 'reduce',
    expression: of,
    reducer: 'sum',
    settings: { mode: 'dropNN' },
  }),

  /** One tier's rule. */
  rule(tier, opts)::
    local o = $.defaults + opts;
    local long = $.allowance(o.budget_usd, tier.burn, tier.long_hours);
    local short = $.allowance(o.budget_usd, tier.burn, tier.short_hours);
    local spent(ref) = '{{ with $values.%s }}{{ printf "%%.2f" .Value }}{{ else }}?{{ end }}' % ref;
    {
      name: '%s - Cost %s' % [o.name_prefix, tier.name],
      rule_group: o.group,
      folder_uid: o.folder_uid,
      interval_seconds: $.interval_seconds,
      // One evaluation: the windows already average over a day or more.
      for_duration: '15m',
      condition: 'C',
      no_data_state: 'OK',
      // Same reasoning as slo/rule.libsonnet: one failed read says nothing about a
      // month's spend. A source that stops writing is the `staleRule`'s job, not this.
      exec_err_state: 'OK',
      labels: o.labels + {
        [o.priority_label]: tier.priority,
        burn_rate: '%g' % tier.burn,
        long_window: '%dh' % tier.long_hours,
      },
      annotations: {
        summary: '%s - Cost %s: $%s in %dh (limit $%.2f)' % [o.name_prefix, tier.name, spent('LS'), tier.long_hours, long],
        description: (
          'The AWS account spent $%(spent)s in the %(long)dh ending %(settle)dh ago, against $%(long_allow).2f allowed ' +
          'at %(burn)gx the pace of its $%(budget)g/month budget, and $%(short_spent)s in the last %(short)dh of that ' +
          '(limit $%(short_allow).2f). The window ends %(settle)dh back because Cost Explorer reports late. ' +
          'Find the line that moved in Cost Explorer: group by usage type, hourly, this account.'
        ) % {
          spent: spent('LS'),
          short_spent: spent('SS'),
          long: tier.long_hours,
          short: tier.short_hours,
          settle: $.settle_hours,
          long_allow: long,
          short_allow: short,
          burn: tier.burn,
          budget: o.budget_usd,
        },
      },
      data: [
        query('L', o, tier.long_hours),
        query('S', o, tier.short_hours),
        sum('LS', 'L'),
        sum('SS', 'S'),
        expression('C', {
          type: 'math',
          expression: '$LS > %f && $SS > %f' % [long, short],
        }),
      ],
    },

  /**
   * Fires when the input stops arriving. Every tier treats no data as OK — a quiet hour
   * cannot be overspend — so without this a broken poller silences all of them for
   * good. Looks for the six settled hours just behind the tiers' windows.
   */
  staleRule(opts)::
    local o = $.defaults + opts;
    {
      name: '%s - Cost data missing' % o.name_prefix,
      rule_group: o.group,
      folder_uid: o.folder_uid,
      interval_seconds: $.interval_seconds,
      for_duration: '1h',
      condition: 'C',
      no_data_state: 'Alerting',
      exec_err_state: 'OK',
      labels: o.labels + { [o.priority_label]: 'P3' },
      annotations: {
        summary: '%s - Cost data missing: no hourly cost recorded for the last settled hours' % o.name_prefix,
        description: (
          'No %(ns)s/%(metric)s datapoints between %(from)dh and %(to)dh ago, so the cost burn-rate alerts are blind. ' +
          'Check the cost reporter Lambda\'s logs and its EventBridge schedule.'
        ) % { ns: o.namespace, metric: o.metric_name, from: $.settle_hours + 6, to: $.settle_hours },
      },
      data: [
        query('A', o, 6),
        expression('B', { type: 'reduce', expression: 'A', reducer: 'count', settings: { mode: 'dropNN' } }),
        expression('C', { type: 'math', expression: '$B < 1' }),
      ],
    },

  /** Every tier plus the staleness guard, as one rule group. */
  ruleGroup(opts)::
    local o = $.defaults + opts;
    assert o.budget_usd > 0 : 'slo/cost.libsonnet: budget_usd must be a positive monthly budget in dollars, got %s' % o.budget_usd;
    assert o.datasource_uid != '' : 'slo/cost.libsonnet: datasource_uid (the CloudWatch datasource) is required';
    {
      name: o.group,
      folder_uid: o.folder_uid,
      interval_seconds: $.interval_seconds,
      rules: [$.rule(t, o) for t in $.tiers] + [$.staleRule(o)],
    },

  /**
   * DASHBOARD PANELS — the alerting made visible, from the same budget and tiers.
   *
   * There is deliberately no rolling-window burn chart: the input must be read at each
   * hour's Maximum (see THE INPUT), CloudWatch metric math has no moving sum, and a
   * Grafana-side window transform is not available on every instance this ships to.
   * Lines at each tier's hourly pace say the same thing more plainly — a tier fires when
   * the hourly cost averages above its line over that tier's windows.
   */
  local panelTarget(o) = {
    refId: 'HourlyCost',
    datasource: { type: 'cloudwatch', uid: o.datasource_uid },
    alias: 'cost per hour',
    queryMode: 'Metrics',
    metricQueryType: 0,
    metricEditorMode: 0,
    region: 'default',
    namespace: o.namespace,
    metricName: o.metric_name,
    dimensions: {},
    matchExact: true,
    statistic: 'Maximum',
    period: '3600',
    id: '',
    expression: '',
  },

  /** Dollars per hour at the budget's sustainable pace. */
  hourly_pace(budget_usd):: budget_usd / $.month_hours,

  hourlyPanel(opts)::
    local o = $.defaults + opts;
    local pace = $.hourly_pace(o.budget_usd);
    local tierColor = { P2: 'red', P3: 'orange' };
    local sorted = std.sort($.tiers, function(t) t.burn);
    {
      type: 'timeseries',
      title: 'AWS cost per hour (budget $%g/month)' % o.budget_usd,
      description: std.join(' ', [
        "The whole AWS account's cost for each billed hour, from Cost Explorer.",
        'Lines mark each alert tier at its hourly pace: %s ($%.2f/h is the budget spent evenly over 30 days).' % [
          std.join(', ', ['%gx = $%.2f/h (%s, %s)' % [t.burn, t.burn * pace, t.name, t.priority] for t in sorted]),
          pace,
        ],
        'A tier fires when the cost averages above its line over that tier\'s long AND short windows, both ending %dh ago.' % $.settle_hours,
        'The newest ~%dh read low: Cost Explorer reports late and those hours are still filling in, so judge spend left of that.' % $.settle_hours,
      ]),
      datasource: { type: 'cloudwatch', uid: o.datasource_uid },
      fieldConfig: {
        defaults: {
          unit: 'currencyUSD',
          decimals: 2,
          min: 0,
          color: { mode: 'palette-classic' },
          custom: {
            drawStyle: 'line',
            lineInterpolation: 'stepAfter',
            lineWidth: 1,
            fillOpacity: 15,
            showPoints: 'never',
            spanNulls: false,
            axisSoftMax: std.foldl(function(m, t) std.max(m, t.burn), $.tiers, 0) * pace * 1.1,
            thresholdsStyle: { mode: 'line' },
          },
          thresholds: {
            mode: 'absolute',
            steps: [{ color: 'green', value: null }] + [
              { color: if t.burn == 1 then 'yellow' else tierColor[t.priority], value: t.burn * pace }
              for t in sorted
            ],
          },
        },
        overrides: [],
      },
      options: {
        legend: { displayMode: 'list', placement: 'bottom', showLegend: true },
        tooltip: { mode: 'single', sort: 'none' },
      },
      targets: [panelTarget(o)],
    },

  local spendGauge(o, title, timeFrom, description) = {
    type: 'gauge',
    title: title,
    description: description,
    timeFrom: timeFrom,
    datasource: { type: 'cloudwatch', uid: o.datasource_uid },
    fieldConfig: {
      defaults: {
        unit: 'currencyUSD',
        decimals: 0,
        min: 0,
        max: o.budget_usd,
        color: { mode: 'thresholds' },
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'yellow', value: 0.9 * o.budget_usd },
            { color: 'red', value: o.budget_usd },
          ],
        },
      },
      overrides: [],
    },
    options: {
      reduceOptions: { calcs: ['sum'], fields: '', values: false },
      showThresholdLabels: false,
      showThresholdMarkers: true,
    },
    targets: [panelTarget(o)],
  },

  /** Spend in the trailing 30 days against the monthly budget — the like-for-like number. */
  trailingPanel(opts)::
    local o = $.defaults + opts;
    spendGauge(o, 'AWS cost, last 30 days (budget $%g)' % o.budget_usd, '30d', std.join(' ', [
      'Sum of hourly cost over the trailing 30 days, against the $%g monthly budget: the like-for-like comparison, since the tiers measure pace against a 30-day month.' % o.budget_usd,
      'Reads up to ~%dh of spend low, because the newest hours are still filling in.' % $.settle_hours,
    ])),

  /** Spend since the 1st, against the monthly budget. */
  monthPanel(opts)::
    local o = $.defaults + opts;
    spendGauge(o, 'AWS cost, this month so far (budget $%g)' % o.budget_usd, 'now/M', std.join(' ', [
      'Sum of hourly cost since the 1st of the month, against the $%g monthly budget.' % o.budget_usd,
      'Early in the month this is naturally a small share of the budget; compare it to how much of the month has passed, or read the 30-day gauge.',
      'Reads up to ~%dh of spend low, because the newest hours are still filling in.' % $.settle_hours,
    ])),

  defaults:: {
    /** Monthly budget for the whole account, in USD. */
    budget_usd: 0,
    /** CloudWatch datasource uid. */
    datasource_uid: '',
    folder_uid: '',
    group: 'Cost',
    name_prefix: '',
    labels: {},
    priority_label: 'priority',
    /** Where the poller writes the hourly cost. */
    namespace: 'Cost',
    metric_name: 'HourlyCostUSD',
  },
}
