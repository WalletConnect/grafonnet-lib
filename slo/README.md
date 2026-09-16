# `slo/` — multiwindow multi-burn-rate SLO alerting

Approach 6 from the Google SRE Workbook chapter
[Alerting on SLOs](https://sre.google/workbook/alerting-on-slos/), as reusable Jsonnet.

Three alert rules cover every SLO a service has — one per burn tier — instead of one
hand-tuned threshold per metric. Severity tracks **how soon the objective breaks**, not
which indicator is burning:

| Tier | Burn | Windows | Priority | 30-day budget gone in |
|---|---|---|---|---|
| fast | 14.4x | 1h + 5m | P0 | ~2.1 days |
| slow | 6x | 6h + 30m | P1 | ~5 days |
| budget | 1x | 3d + 6h | P3 | 30 days — i.e. the objective is simply being missed |

| File | What it is |
|---|---|
| `burn_rate.libsonnet` | The mechanics: tier table, budget sizing, the PromQL conditions. Start here — the design rationale lives in its comments. |
| `rule.libsonnet` | Turns tiers + your SLIs into Grafana Unified Alerting rule groups. |
| `panels.libsonnet` | The burn-rate chart and the error-budget bar gauge. |
| `tests/` | promtool suites over the shipping expressions, driven by fixture SLIs. |

## What you supply

An **SLI table**: a list of objects, each with an objective and two PromQL **counts** per
window. Everything here counts events against a budget; nothing takes a rate.

```jsonnet
{
  key: 'api-availability',            // lands on the alert as the `sli` label
  objective: 0.99,                    // a RATIO, not a percentage
  objective_text: '99% of requests non-5xx',
  bad(w):: 'sum(increase(http_requests_total{code=~"5.."}[%s]))' % w,
  events(w):: 'sum(increase(http_requests_total[%s]))' % w,
  // tiers: ['budget'],               // optional; see "Loose objectives" below
}
```

`bad` and `events` **must aggregate identically** — same `by` labels — because they are
divided and `and`-ed, and a mismatch silently drops every series.

## Wiring it up

```jsonnet
local sloRule   = import 'grafonnet-lib/slo/rule.libsonnet';
local sloPanels = import 'grafonnet-lib/slo/panels.libsonnet';
local slis      = import 'slis.libsonnet';

// Alerts: yields one rule group PER TIER, so concatenate rather than append.
{
  rule_groups: [ appAlerts.ruleGroup(...) ] + sloRule.ruleGroups(ds, folder_uid, slis, {
    name_prefix:    vars.envCapitalized,
    labels:         vars.labels,
    priority_label: 'og_priority',        // default 'priority'
    dimension_hint: 'Any chain_id label on this instance names the chain that is burning.',
    dashboard_hint: "then that chain's row under Chain RPC Router.",
  }),
}

// Panels:
sloPanels.burn_rate(ds, slis, { dimension_word: 'chain' })        { gridPos: pos._1 },
sloPanels.budget_remaining(ds, slis, { dimension_word: 'chain' }) { gridPos: pos_short._2 },
```

If your Terraform enumerates rule groups statically — it usually must, because the names
become `for_each` keys and cannot be known after apply — list all three group names
(`SLO Fast Burn`, `SLO Slow Burn`, `SLO Error Budget`) there too. A group that renders
but is not listed is silently never provisioned.

## Things that will bite you

**Read `burn_rate.libsonnet`'s header before tuning anything.** The tier percentages are
derived from the burn multiples; changing one without the other makes the panel's
threshold lines disagree with the rules.

**Loose objectives cannot fire the fast tiers, and this is arithmetic.** A 25% error
budget cannot be over-spent inside an hour: even a total outage spends 0.56% of the month
against the fast tier's 2%. Floors are 93.06% for 14.4x and 83.33% for 6x. An SLI below
those **must** declare `tiers: ['budget']`; `burn_rate.tier_feasible` fails the render
otherwise, deliberately, because the alternative is a rule that looks like coverage and
can never fire.

**The noise floor guards BAD events, never traffic** (`min_bad_events`, default 2). A
floor on request volume silences a total outage on a quiet dimension exactly as
effectively as it silences one stray error.

**Override, don't fork.** Every knob is a hidden field:
`burnRate + { min_bad_events:: 3 }`, or pass `burn_rate:` to `rule.libsonnet` /
`panels.libsonnet` to use a retuned tier table.

**A compliance tile and a burn rate answer different questions.** A 95% objective grants
a 5% budget, so an indicator at 94% is missing its SLO while being nowhere near a page.
Ship `panels.libsonnet` alongside your tiles or on-call will conflate the two.

## Testing

```sh
cd slo/tests
jsonnet -o /dev/null smoke.jsonnet          # renders rules + panels from fixtures
jsonnet -S -m . render_rules.jsonnet        # emits promtool rule files
promtool test rules *_test.yaml
```

The suites test the **mechanics** against fixture SLIs — window arithmetic, budget
sizing, the noise floor, expression splicing, the sparse-denominator hazard, and that the
panels agree with the rules about the size of the budget. Whether *your* objective is the
right number is your repo's business and belongs in your repo's tests.

Requires **go-jsonnet** (`brew install go-jsonnet`), matching Terraform's
`alxrem/jsonnet` provider. The C++ build renders these fine but differs on stack depth
for large dashboards.
