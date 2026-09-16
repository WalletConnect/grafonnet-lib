local sloRule = import '../rule.libsonnet';
local sloPanels = import '../panels.libsonnet';
local fixtures = import 'fixtures.libsonnet';
local ds = { prometheus: { type: 'prometheus', uid: 'p' }, prometheus_uid: 'p' };
{
  groups: sloRule.ruleGroups(ds, 'folder', fixtures.slis, {
    name_prefix: 'Prod',
    labels: { environment: 'prod' },
    priority_label: 'og_priority',
    dimension_hint: 'Any route label names the route that is burning.',
    dashboard_hint: 'then the per-route panel.',
  }),
  burn_panel: sloPanels.burn_rate(ds, fixtures.slis, { dimension_word: 'route' }),
  budget_panel: sloPanels.budget_remaining(ds, fixtures.slis, { dimension_word: 'route' }),
}
