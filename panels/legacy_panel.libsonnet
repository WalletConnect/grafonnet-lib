local defaults = {
  title:          '',
  pluginVersion:  '8.4.7',
};

{
  /**
   * Dashboard panel.
   *
   * @name timeseries_panel.new
   *
   * @param title The title of the singlestat panel.


   * @method addTarget(target) Adds a target object.
   * @method addTargets(targets) Adds an array of targets.
   * @method addLink(link) Adds a [panel link](https://grafana.com/docs/grafana/latest/linking/panel-links/).
   * @method addLinks(links) Adds an array of links.
   */
  old_new(
    title           = $.defaults.title,
    tags            = null,
    timeRegions     = null,
    transformations = null,
  )::
    self {
      // Configuration
      configure(configuration):: self {
        fieldConfig+: configuration.fieldConfig,
//        options+:     configuration.options,
      },
    },
}
