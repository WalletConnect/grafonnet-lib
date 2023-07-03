local common        = import '../common.libsonnet';
local panel         = import 'panel.libsonnet';

{
  /**
   * Create a new dashboard panel.
   *
   * @param title               string                        Panel title.
   * @param description         string                        Panel description.
   * @param datasource          DataSourceRef                 The datasource used in all targets.
   * @param fieldConfig         FieldConfigSource             Field options allow you to change how the data is displayed in your visualizations.
   * @param interval            string                        The min time interval setting defines a lower limit for the `interval` and `interval_ms` variables.
   *                                                          This value must be formatted as a number followed by a valid time identifier like: "40s", "3d", etc.
   * @param libraryPanel        LibraryPanelRef               Dynamically load the panel.
   * @param maxDataPoints       number                        The maximum number of data points that the panel queries are retrieving.
   * @param repeat              string                        Name of template variable to repeat for.
   * @param repeatDirection     RepeatDirection               Direction to repeat in if 'repeat' is set.
   * @param repeatPanelId       number                        Id of the repeating panel.
   * @param timeFrom            string                        Overrides the relative time range for individual panels, which causes them to be different than what is selected in the dashboard time picker in the top-right corner of the dashboard.
   *                                                          The value is formatted as time operation like: `now-5m` (Last 5 minutes), `now/d` (the day so far), `now-5d/d`(Last 5 days), `now/w` (This week so far), `now-2y/y` (Last 2 years).
   * @param timeShift           string                        Overrides the time range for individual panels by shifting its start and end relative to the time picker.
   *                                                          For example, you can shift the time range for the panel to be two hours earlier than the dashboard time picker setting `2h`.
   * @param transparent         boolean                       Whether to display the panel without a background.
   * @param links               Array<DashboardLink>          Panel links.
   * @param tags                Array<string>                 Tags for the panel.
   * @param transformations     Array<DataTransformerConfig>  List of transformations that are applied to the panel data before rendering.
   *                                                          When there are multiple transformations, Grafana applies them in the order they are listed.
   *                                                          Each transformation creates a result set that then passes on to the next transformation in the processing pipeline.
   * @param targets             Array<Target>                 The targets to query for the panel.
   * @param options
   * @param thresholds          ThresholdsConfig              Map numeric values to states.
   * @param pluginVersion       string                        The version of the plugin that is used for this panel. This is used to find the plugin to display the panel and to migrate old panel configs.
   */
  new(
    title,
    description     = null,
    datasource      = null,
    fieldConfig     = null,
    interval        = null,
    libraryPanel    = null,
    maxDataPoints   = null,
    repeat          = null,
    repeatDirection = null,
    repeatPanelId   = null,
    timeFrom        = null,
    timeShift       = null,
    transparent     = false,
    links           = null,
    tags            = null,
    transformations = null,
    alert           = null,
    targets         = null,
    options         = null,
    thresholds      = null,

    pluginVersion   = defaults.pluginVersion,
  ):: panel.new(
    title,
    description     = null,
    datasource      = null,
    fieldConfig     = null,
    interval        = null,
    libraryPanel    = null,
    maxDataPoints   = null,
    repeat          = null,
    repeatDirection = null,
    repeatPanelId   = null,
    timeFrom        = null,
    timeShift       = null,
    transparent     = false,
    links           = null,
    tags            = null,
    transformations = null,
    alert           = null,
    targets         = null,
    options         = null,
    thresholds      = null,
  ) {
    type:         'timeseries',


  /**
   * @param configuration       common.GraphFieldConfig       The configuration to apply.
   */
    configure(configuration):: self {
      fieldConfig+: configuration,
    },
  }
}
