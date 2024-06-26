local timepickerlib = import 'timepicker.libsonnet';

{
  /**
   * Creates a [dashboard](https://grafana.com/docs/grafana/latest/features/dashboard/dashboards/)
   *
   * @name dashboard.new
   *
   * @param title                           The title of the dashboard
   * @param editable (default: `false`)     Whether the dashboard is editable via Grafana UI.
   * @param style (default: `'dark'`)       Theme of dashboard, `'dark'` or `'light'`
   * @param tags (optional)                 Array of tags associated to the dashboard, e.g.`['tag1','tag2']`
   * @param time_from (default: `'now-6h'`)
   * @param time_to (default: `'now'`)
   * @param timezone (default: `'browser'`) Timezone of the dashboard, `'utc'` or `'browser'`
   * @param refresh (default: `''`)         Auto-refresh interval, e.g. `'30s'`
   * @param timepicker (optional)           See timepicker API
   * @param graphTooltip (default: `'default'`) `'default'` : no shared crosshair or tooltip (0), `'shared_crosshair'`: shared crosshair (1), `'shared_tooltip'`: shared crosshair AND shared tooltip (2)
   * @param hideControls (default: `false`)
   * @param schemaVersion (default: `35`)   Version of the Grafana JSON schema.
   * @param uid (default: `''`)             Unique dashboard identifier as a string (8-40), that can be chosen by users. Used to identify a dashboard to update when using Grafana REST API.
   * @param description (optional)
   * @param liveNow (default: `false`)      When set to true, the dashboard will redraw panels at an interval matching the pixel width.
   *
   * @method addTemplate(template)          Add a template variable
   * @method addTemplates(templates)        Adds an array of template variables
   * @method addAnnotation(annotation)      Add an [annotation](https://grafana.com/docs/grafana/latest/dashboards/annotations/)
   * @method addPanel(panel,gridPos)        Appends a panel, with an optional grid position in grid coordinates, e.g. `gridPos={'x':0, 'y':0, 'w':12, 'h': 9}`
   * @method addPanels(panels)              Appends an array of panels
   * @method addLink(link)                  Adds a [dashboard link](https://grafana.com/docs/grafana/latest/linking/dashboard-links/)
   * @method addLinks(dashboardLink)        Adds an array of [dashboard links](https://grafana.com/docs/grafana/latest/linking/dashboard-links/)
   * @method addRequired(type, name, id, version)
   * @method addInput(name, label, type, pluginId, pluginName, description, value)
   * @method addRow(row)                    Adds a row. This is the legacy row concept from Grafana < 5, when rows were needed for layout. Rows should now be added via `addPanel`.
   */
  new(
    title,
    editable      = false,
    style         = self.styles.dark,
    tags          = [],
    time_from     = 'now-6h',
    time_to       = 'now',
    timezone      = self.timezones.utc,
    refresh       = '',
    timepicker    = timepickerlib.new(),
    graphTooltip  = self.graphTooltips.default,
    hideControls  = false,
    schemaVersion = 35,
    uid           = '',
    description   = null,
    liveNow       = false,
    weekStart     = null,
  ):: {
    local it = self,
    _annotations:: [],
    [if uid != '' then 'uid']: uid,
    editable: editable,
    [if description != null then 'description']: description,
    gnetId: null,
    graphTooltip: graphTooltip,
    hideControls: hideControls,
    id: null,
    links: [],
    liveNow: liveNow,
    panels:: [],
    refresh: refresh,
    rows: [],
    schemaVersion: schemaVersion,
    style: style,
    tags: tags,
    time: {
      from: time_from,
      to: time_to,
    },
    timezone: timezone,
    timepicker: timepicker,
    title: title,
    [if weekStart != null then 'weekStart']: weekStart,
    version: 0,

    addAnnotations(annotations):: self {
      _annotations+:: annotations,
    },
    addAnnotation(a):: self.addAnnotations([a]),
    annotations: { list: it._annotations },

    addTemplates(templates):: self {
      templates+: templates,
    },
    addTemplate(t):: self.addTemplates([t]),
    templates:: [],

    templating: { list: it.templates },

    _nextPanel:: 2,

    addRow(row)::
      self.addPanels([row] + row.panels),

    addPanels(newpanels)::
      self {
        // automatically number panels in added rows.
        // https://github.com/kausalco/public/blob/master/klumps/grafana.libsonnet
        local n = std.foldl(function(numOfPanels, p)
          (if 'panels' in p then
             numOfPanels + 1 + std.length(p.panels)
           else
             numOfPanels + 1), newpanels, 0),
        local nextPanel = super._nextPanel,
        local _panels = std.makeArray(
          std.length(newpanels), function(i)
            newpanels[i] {
              id: nextPanel + (
                if i == 0 then
                  0
                else
                  if 'panels' in _panels[i - 1] then
                    (_panels[i - 1].id - nextPanel) + 1 + std.length(_panels[i - 1].panels)
                  else
                    (_panels[i - 1].id - nextPanel) + 1

              ),
              [if 'panels' in newpanels[i] then 'panels']: std.makeArray(
                std.length(newpanels[i].panels), function(j)
                  newpanels[i].panels[j] {
                    id: 1 + j +
                        nextPanel + (
                      if i == 0 then
                        0
                      else
                        if 'panels' in _panels[i - 1] then
                          (_panels[i - 1].id - nextPanel) + 1 + std.length(_panels[i - 1].panels)
                        else
                          (_panels[i - 1].id - nextPanel) + 1

                    ),
                  }
              ),
            }
        ),

        _nextPanel: nextPanel + n,
        panels+::: _panels,
      },

    addPanel(panel, gridPos):: self.addPanels([panel { gridPos: gridPos }]),
    addRows(rows):: std.foldl(function(d, row) d.addRow(row), rows, self),
    addLink(link):: self {
      links+: [link],
    },
    addLinks(dashboardLinks):: std.foldl(function(d, t) d.addLink(t), dashboardLinks, self),

    required:: [],
    __requires: it.required,
    addRequired(type, name, id, version):: self {
      required+: [{ type: type, name: name, id: id, version: version }],
    },

    inputs:: [],
    __inputs: it.inputs,
    addInput(
      name,
      label,
      type,
      pluginId=null,
      pluginName=null,
      description='',
      value=null,
    ):: self {
      inputs+: [{
        name: name,
        label: label,
        type: type,
        [if pluginId != null then 'pluginId']: pluginId,
        [if pluginName != null then 'pluginName']: pluginName,
        [if value != null then 'value']: value,
        description: description,
      }],
    },
  },

  styles:: {
    light:  'light',
    dark:   'dark',
  },

  timezones:: {
    browser:  'browser',
    utc:      'utc',
  },

  graphTooltips:: {
    default:          0,
    sharedCrosshair:  1,
    sharedTooltip:    2,
  },
}
