{
  colors:: import './colors.libsonnet',
  /**
   * These are the common properties available to all queries in all datasources.
   * Specific implementations will *extend* this interface, adding the required
   * properties for the given context.
   *
   * @param datasource          unknown                       For mixed data sources the selected datasource is on the query level.
   *                                                          For non mixed scenarios this is undefined.
   * @param hide                boolean                       true if query is disabled (ie should not be returned to the dashboard)
   * @param queryType           string                        Specify the query flavor (ie query type)
   */
  DataQuery(
    datasource        = null,
    hide              = false,
    queryType         = '',
  ):: {
    [if datasource          != null then 'datasource'         ]: datasource,
    [if hide                != null then 'hide'               ]: hide,
    [if queryType           != null then 'queryType'          ]: queryType,
  },

  /**
   * @param field               string
   */
  BaseDimensionConfig(
    field,
  ):: {
    field:              field,
  },
  /**
   * @param field               string
   * @param mode                $.scaleDimensionMode
   * @param min                 number
   * @param max                 number
   * @param fixed               number
   */
  ScaleDimensionConfig(
    field,
    mode,
    min,
    max,
    fixed             = null,
  ):: $.BaseDimensionConfig(field) {
    mode:               mode,
    [if fixed               != null then 'fixed'              ]: fixed,
    min:                min,
    max:                max,
  },
  /**
   * @param field               string
   * @param fixed               string                        Color value
   */
  ColorDimensionConfig(
    field,
    fixed             = null,
  ):: $.BaseDimensionConfig(field) {
    [if fixed               != null then 'fixed'              ]: fixed,
  },
  /**
   * @param field               string
   * @param mode                $.scaleDimensionMode
   * @param min                 number
   * @param max                 number
   * @param fixed               number
   */
  ScalarDimensionConfig(
    field,
    mode,
    min,
    max,
    fixed             = null,
  ):: $.BaseDimensionConfig(field) {
    mode:               mode,
    [if fixed               != null then 'fixed'              ]: fixed,
    min:                min,
    max:                max,
  },
  /**
   * @param field               string
   * @param mode                $.textDimensionMode
   * @param fixed               number
   */
  TextDimensionConfig(
    field,
    mode,
    fixed             = null,
  ):: $.BaseDimensionConfig(field) {
    mode:               mode,
    [if fixed               != null then 'fixed'              ]: fixed,
  },

  /**
   * @param name                string                        Configured unique display name
   * @param type                string                        The type of the datasource
   * @param config              unknown                       Layer specific configuration
   * @param filterData          unknown                       Defines a frame MatcherConfig that may filter data for the given layer
   * @param location            $.frameGeometrySource         Common method to define geometry fields
   * @param opacity             number                        Layer opacity (0-1)
   * @param tooltip             boolean                       Enable/disable tooltip
   */
  MapLayerOptions(
    name,
    type,
    config            = null,
    filterData        = null,
    location          = null,
    opacity           = null,
    tooltip           = true,
  ):: {
    name:               name,
    type:               type,
    [if config              != null then 'config'           ]: config,
    [if filterData          != null then 'filterData'       ]: filterData,
    [if location            != null then 'location'         ]: location,
    [if opacity             != null then 'opacity'          ]: opacity,
    [if tooltip             != null then 'tooltip'          ]: tooltip,
  },

  /**
   * @param mode                $.heatmapCalculationMode      Sets the bucket calculation mode
   * @param scale               $.scaleDistributionConfig     Controls the scale of the buckets
   * @param value               string                        The number of buckets to use for the axis in the heatmap
   */
  HeatmapCalculationBucketConfig(
    mode              = null,
    scale             = null,
    value             = null,
  ):: {
    [if mode                != null then 'mode'               ]: mode,
    [if scale               != null then 'scale'              ]: scale,
    [if value               != null then 'value'              ]: value,
  },

  /**
   * @param fill                $.fillStyle                   Fill style
   * @param dash                Array<number>                 Dash pattern
   */
  LineStyle(
    fill              = $.lineStyle.Solid,
    dash              = null,
  ):: {
    fill:               fill,
    [if dash                != null then 'dash'               ]: dash,
  },

  /**
   * @param lineColor           string                        Line color
   * @param lineInterpolation   $.lineInterpolation           Line interpolation mode;
   * @param lineStyle           $.lineStyle                   Line style
   * @param lineWidth           number                        Line width
   * @param spanNulls           boolean | number              Indicate if null values should be treated as gaps or connected.
   *                                                          When the value is a number, it represents the maximum delta in the X axis that should be considered connected.
   *                                                          For timeseries, this is milliseconds.
   */
  LineConfig(
    lineColor         = null,
    lineInterpolation = null,
    lineStyle         = null,
    lineWidth         = null,
    spanNulls         = null,
  ):: {
    [if lineColor           != null then 'lineColor'          ]: lineColor,
    [if lineInterpolation   != null then 'lineInterpolation'  ]: lineInterpolation,
    [if lineStyle           != null then 'lineStyle'          ]: lineStyle,
    [if lineWidth           != null then 'lineWidth'          ]: lineWidth,
    [if spanNulls           != null then 'spanNulls'          ]: spanNulls,
  },

  /**
   * @param barAlignment        $.barAlignment                Bar alignment
   * @param barMaxWidth         number                        Maximum bar width
   * @param barWidthFactor      number                        Bar width factor
   */
  BarConfig(
    barAlignment      = null,
    barMaxWidth       = null,
    barWidthFactor    = null,
  ):: {
    [if barAlignment        != null then 'barAlignment'       ]: barAlignment,
    [if barMaxWidth         != null then 'barMaxWidth'        ]: barMaxWidth,
    [if barWidthFactor      != null then 'barWidthFactor'     ]: barWidthFactor,
  },

  /**
   * @param fillBelowTo        string                         Fill below to field name
   * @param fillColor          string                         Fill color
   * @param fillOpacity        number                         Fill opacity
    */
  FillConfig(
    fillBelowTo       = null,
    fillColor         = null,
    fillOpacity       = null,
  ):: {
    [if fillBelowTo         != null then 'fillBelowTo'        ]: fillBelowTo,
    [if fillColor           != null then 'fillColor'          ]: fillColor,
    [if fillOpacity         != null then 'fillOpacity'        ]: fillOpacity,
  },

  /**
   * @param pointColor         string                         Point color
   * @param pointSize          number                         Point size
   * @param pointSymbol        string                         Point symbol
   * @param showPoints         $.visibilityMode               Show points
   */
  PointsConfig(
    pointColor        = null,
    pointSize         = null,
    pointSymbol       = null,
    showPoints        = null,
  ):: {
    [if pointColor          != null then 'pointColor'         ]: pointColor,
    [if pointSize           != null then 'pointSize'          ]: pointSize,
    [if pointSymbol         != null then 'pointSymbol'        ]: pointSymbol,
    [if showPoints          != null then 'showPoints'         ]: showPoints,
  },

  /**
    * @param linearThreshold    number
    * @param log                number
    * @param type               $.scaleDistribution
    */
  ScaleDistributionConfig(
    linearThreshold   = null,
    log               = null,
    type              = null,
  ):: {
    [if linearThreshold     != null then 'linearThreshold'    ]: linearThreshold,
    [if log                 != null then 'log'                ]: log,
    [if type                != null then 'type'               ]: type,
  },

  /**
   * @param axisCenteredZero    boolean                       Center the Y axis at zero
   * @param axisColorMode       $.axisColorMode               Axis color mode
   * @param axisGridShow        boolean                       Show axis grid
   * @param axisLabel           string                        Axis label
   * @param axisPlacement       $.axisPlacement               Axis placement
   * @param axisSoftMax         number                        Soft maximum value
   * @param axisSoftMin         number                        Soft minimum value
   * @param axisWidth           number                        Axis width
   * @param scaleDistribution   $.scaleDistribution           Controls the scale of the axis.
   */
  AxisConfig(
    axisCenteredZero  = null,
    axisColorMode     = null,
    axisGridShow      = null,
    axisLabel         = null,
    axisPlacement     = null,
    axisSoftMax       = null,
    axisSoftMin       = null,
    axisWidth         = null,
    scaleDistribution = null,
  ):: {
    [if axisCenteredZero    != null then 'axisCenteredZero'   ]: axisCenteredZero,
    [if axisColorMode       != null then 'axisColorMode'      ]: axisColorMode,
    [if axisGridShow        != null then 'axisGridShow'       ]: axisGridShow,
    [if axisLabel           != null then 'axisLabel'          ]: axisLabel,
    [if axisPlacement       != null then 'axisPlacement'      ]: axisPlacement,
    [if axisSoftMax         != null then 'axisSoftMax'        ]: axisSoftMax,
    [if axisSoftMin         != null then 'axisSoftMin'        ]: axisSoftMin,
    [if axisWidth           != null then 'axisWidth'          ]: axisWidth,
    [if scaleDistribution   != null then 'scaleDistribution'  ]: scaleDistribution,
  },

  /**
   * @param legend              boolean
   * @param tooltip             boolean
   * @param viz                 boolean
   */
  HideSeriesConfig(
    legend,
    tooltip,
    viz,
  ):: {
    legend:             legend,
    tooltip:            tooltip,
    viz:                viz,
  },

  /**
   * @param group               string                        Group name
   * @param mode                $.stackingMode                Stacking mode
   */
  StackingConfig(
    group             = null,
    mode              = null,
  ):: {
    [if group               != null then 'group'              ]: group,
    [if mode                != null then 'mode'               ]: mode,
  },

  /**
   * @param stacking            $.StackingConfig              Stacking configuration
   */
  StackableFieldConfig(
    stacking          = null,
  ):: {
    [if stacking            != null then 'stacking'           ]: stacking,
  },

  /**
   * @param hideFrom            $.HideSeriesConfig            Hide series configuration
   */
  HideableFieldConfig(
    hideFrom          = null
  ):: {
    [if hideFrom            != null then 'hideFrom'           ]: hideFrom,
  },

  /**
   * @param mode                $.graphTresholdsStyleMode,
   */
  GraphThresholdsStyleConfig(
    mode
  ):: {
    mode:               mode,
  },

  /**
   * @param orientation         $.vizOrientation
   * @param reduceOptions       $.ReduceDataOptions
   */
  SingleStatBaseOptions(
    orientation,
    reduceOptions,
  ):: $.OptionsWithTextFormatting {
    orientation:        orientation,
    reduceOptions:      reduceOptions,
  },

  /**
   * @param calcs               Array<string>                 When !values, pick one value for the whole field
   * @param fields              string                        Which fields to show. By default this is only numeric fields
   * @param limit               number                        limit if showing all values
   * @param values              boolean                       If true show each row value
   */
  ReduceDataOptions(
    calcs             = [],
    fields            = null,
    limit             = null,
    values            = null,
  ):: {
    [if calcs               != null then 'calcs'              ]: calcs,
    [if fields              != null then 'fields'             ]: fields,
    [if limit               != null then 'limit'              ]: limit,
    [if values              != null then 'values'             ]: values,
  },

  /**
   * @param tooltip             $.vizTooltipOptions
   */
  OptionsWithTooltip(
    tooltip,
  ):: {
    tooltip:            tooltip,
  },
  /**
   * @param legend              $.vizLegendOptions
   */
  OptionsWithLegend(
    legend,
  ):: {
    legend:             legend,
  },
  /**
   * @param timezone            Array<$.timeZone>
   */
  OptionsWithTimezones(
    timezone          = [],
  ):: {
    timezone:           timezone,
  },
  /**
   * @param text                $.vizTextDisplayOptions
   */
  OptionsWithTextFormatting(
    text              = null,
  ):: {
    [if text                != null then 'text'               ]: text,
  },

  /**
   * @param titleSize           number                        Explicit title text size
   * @param valueSize           number                        Explicit value text size
   */
  VizTextDisplayOptions(
    titleSize         = null,
    valueSize         = null,
  ):: {
    [if titleSize           != null then 'titleSize'          ]: titleSize,
    [if valueSize           != null then 'valueSize'          ]: valueSize,
  },

  /**
   * @param drawStyle           $.graphDrawStyle
   * @param gradientMode        $.graphGradientMode
   * @param thresholdsStyle     $.graphThresholdsStyleConfig
   * @param transform           $.graphTransform
   *
   * @param lineColor           string                        Line color
   * @param lineInterpolation   $.lineInterpolation           Line interpolation mode;
   * @param lineStyle           $.lineStyle                   Line style
   * @param lineWidth           number                        Line width
   * @param spanNulls           boolean | number              Indicate if null values should be treated as gaps or connected.
   *                                                          When the value is a number, it represents the maximum delta in the X axis that should be considered connected.
   *                                                          For timeseries, this is milliseconds.
   *
   * @param fillBelowTo        string                         Fill below to field name
   * @param fillColor          string                         Fill color
   * @param fillOpacity        number                         Fill opacity
   *
   * @param pointColor         string                         Point color
   * @param pointSize          number                         Point size
   * @param pointSymbol        string                         Point symbol
   * @param showPoints         $.visibilityMode               Show points
   *
   * @param axisCenteredZero    boolean                       Center the Y axis at zero
   * @param axisColorMode       $.axisColorMode               Axis color mode
   * @param axisGridShow        boolean                       Show axis grid
   * @param axisLabel           string                        Axis label
   * @param axisPlacement       $.axisPlacement               Axis placement
   * @param axisSoftMax         number                        Soft maximum value
   * @param axisSoftMin         number                        Soft minimum value
   * @param axisWidth           number                        Axis width
   * @param scaleDistribution   $.scaleDistribution           Controls the scale of the axis.
   *
   * @param barAlignment        $.barAlignment                Bar alignment
   * @param barMaxWidth         number                        Maximum bar width
   * @param barWidthFactor      number                        Bar width factor
   *
   * @param stacking            $.StackingConfig              Stacking configuration
   *
   * @param hideFrom            $.HideSeriesConfig            Hide series configuration
   */
  GraphFieldConfig(
    drawStyle         = null,
    gradientMode      = null,
    thresholdsStyle   = null,
    transform         = null,

    lineColor         = null,
    lineInterpolation = null,
    lineStyle         = null,
    lineWidth         = null,
    spanNulls         = null,

    fillBelowTo       = null,
    fillColor         = null,
    fillOpacity       = null,

    pointColor        = null,
    pointSize         = null,
    pointSymbol       = null,
    showPoints        = null,

    axisCenteredZero  = null,
    axisColorMode     = null,
    axisGridShow      = null,
    axisLabel         = null,
    axisPlacement     = null,
    axisSoftMax       = null,
    axisSoftMin       = null,
    axisWidth         = null,
    scaleDistribution = null,

    barAlignment      = null,
    barMaxWidth       = null,
    barWidthFactor    = null,

    stacking          = null,

    hideFrom          = null
  )::   $.LineConfig(
          lineColor         = lineColor,
          lineInterpolation = lineInterpolation,
          lineStyle         = lineStyle,
          lineWidth         = lineWidth,
          spanNulls         = spanNulls,
        )
      + $.FillConfig(
          fillBelowTo       = fillBelowTo,
          fillColor         = fillColor,
          fillOpacity       = fillOpacity,
        )
      + $.PointsConfig(
          pointColor        = pointColor,
          pointSize         = pointSize,
          pointSymbol       = pointSymbol,
          showPoints        = showPoints,
        )
      + $.AxisConfig(
          axisCenteredZero  = axisCenteredZero,
          axisColorMode     = axisColorMode,
          axisGridShow      = axisGridShow,
          axisLabel         = axisLabel,
          axisPlacement     = axisPlacement,
          axisSoftMax       = axisSoftMax,
          axisSoftMin       = axisSoftMin,
          axisWidth         = axisWidth,
          scaleDistribution = scaleDistribution,
        )
      + $.BarConfig(
          barAlignment      = barAlignment,
          barMaxWidth       = barMaxWidth,
          barWidthFactor    = barWidthFactor,
        )
      + $.StackableFieldConfig(
          stacking          = stacking,
        )
      + $.HideableFieldConfig(
          hideFrom          = hideFrom,
        ) {
    [if drawStyle         != null then 'drawStyle'          ]: drawStyle,
    [if gradientMode      != null then 'gradientMode'       ]: gradientMode,
    [if thresholdsStyle   != null then 'thresholdsStyle'    ]: thresholdsStyle,
    [if transform         != null then 'transform'          ]: transform,
  },

  /**
   * @param displayMode         $.legendDisplayMode
   * @param placement           $.legendPlacement
   * @param showLegend          boolean
   * @param asTable             boolean
   * @param calcs               Array<string>
   * @param isVisible           boolean
   * @param sortBy              string
   * @param sortDesc            boolean
   * @param width               number
   */
  VizLegendOptions(
    displayMode,
    placement,
    showLegend,
    asTable           = null,
    calcs             = [],
    isVisible         = null,
    sortBy            = null,
    sortDesc          = null,
    width             = null,
  ):: {
    [if asTable             != null then 'asTable'            ]: asTable,
    calcs:              [],
    displayMode:        displayMode,
    [if isVisible           != null then 'isVisible'          ]: isVisible,
    placement:          placement,
    showLegend:         showLegend,
    [if sortBy              != null then 'sortBy'             ]: sortBy,
    [if sortDesc            != null then 'sortDesc'           ]: sortDesc,
    [if width               != null then 'width'              ]: width,
  },

  /**
   * @param mode                $.tooltipDisplayMode
   * @param sort                $.SortOrder
   */
  VizTooltipOptions(
    mode,
    sort,
  ):: {
    mode:               mode,
    sort:               sort,
  },

  /**
   * @param displayMode         string                        Sets the display name of the field to sort by
   * @param desc                boolean                       Flag used to indicate descending sort order
   */
  TableSortByFieldState(
    displayName,
    desc              = null,
  ):: {
    [if desc                != null then 'desc'               ]: desc,
    displayName:        displayName,
  },

  /**
   * @param show                boolean                       Show the table footer
   * @param countRows           boolean
   * @param enablePagination    boolean
   * @param fields              Array<string>
   * @param reducer             Array<string>                 Actually 1 value
   */
  TableFooterOptions(
    show,
    countRows         = null,
    enablePagination  = null,
    fields            = [],
    reducer           = [],
  ):: {
    [if countRows           != null then 'countRows'          ]: countRows,
    [if enablePagination    != null then 'enablePagination'   ]: enablePagination,
    [if fields              != null then 'fields'             ]: fields,
    [if reducer             != null then 'reducer'            ]: reducer,
    show:               show,
  },

  /**
   * @param type                $.tableCellDisplayMode
   */
  TableAutoCellOptions(
    type              = $.tableCellDisplayMode.Auto,
  ):: {
    type:               type,
  },
  /**
   * @param type                $.tableCellDisplayMode
   */
  TableColorTextCellOptions(
    type              = $.tableCellDisplayMode.ColorText,
  ):: {
    type:               type,
  },
  /**
   * @param type                $.tableCellDisplayMode
   */
  TableJsonViewCellOptions(
    type              = $.tableCellDisplayMode.JSONView,
  ):: {
    type:               type,
  },
  /**
   * @param type                $.tableCellDisplayMode
   */
  TableImageCellOptions(
    type              = $.tableCellDisplayMode.Image,
  ):: {
    type:               type,
  },
  /**
   * @param type                $.tableCellDisplayMode
   * @param mode                $.barGaugeDisplayMode
   * @param valueDisplayMode    $.barGaugeValueMode
   */
  TableBarGaugeCellOptions(
    type              = $.tableCellDisplayMode.Gauge,
    mode              = null,
    valueDisplayMode  = null,
  ):: {
    type:               type,
    [if mode                != null then 'mode'               ]: mode,
    [if valueDisplayMode    != null then 'valueDisplayMode'   ]: valueDisplayMode,
  },
  /**
   * @param type                $.tableCellDisplayMode
   */
  TableSparklineCellOptions(
    type              = $.tableCellDisplayMode.Sparkline,
  ):: $.GraphFieldConfig {
    type:               type,
  },
  /**
   * @param type                $.tableCellDisplayMode
   * @param mode                $.tableCellBackgroundDisplayMode
   */
  TableColoredBackgroundCellOptions(
    type              = $.tableCellDisplayMode.ColorBackground,
    mode              = null,
  ):: {
    type:               type,
    [if mode                != null then 'mode'               ]: mode,
  },

  /**
   * @param type                string                        The plugin type-id
   * @param uid                 string                        Specific datasource instance
   */
  DataSourceRef(
    type              = null,
    uid               = null,
  ):: {
    [if type                != null then 'type'               ]: type,
    [if uid                 != null then 'uid'                ]: uid,
  },

  /**
   * Links to a resource (image/svg path)
   *
   * @param mode                $.resourceDimensionMode
   * @param fixed               string                        Path to resource
   */
  ResourceDimensionConfig(
    mode,
    fixed             = null,
  ):: $.BaseDimensionConfig {
    [if fixed               != null then 'fixed'              ]: fixed,
    mode:               mode,
  },

  /**
   * @param mode                $.frameGeometrySourceMode
   * @param gazetteer           string                        Path to Gazetteer
   * @param geohash             string                        Field mappings
   * @param latitude            string
   * @param longitude           string
   * @param lookup              string
   * @param wkt                 string
   */
  FrameGeometrySource(
    mode,
    gazetteer         = null,
    geohash           = null,
    latitude          = null,
    longitude         = null,
    lookup            = null,
    wkt               = null,
  ):: {
    [if gazetteer           != null then 'gazetteer'          ]: gazetteer,
    [if geohash             != null then 'geohash'            ]: geohash,
    [if latitude            != null then 'latitude'           ]: latitude,
    [if longitude           != null then 'longitude'          ]: longitude,
    [if lookup              != null then 'lookup'             ]: lookup,
    mode:               mode,
    [if wkt                 != null then 'wkt'                ]: wkt,
  },

  /**
   * @param xBuckets            $.heatmapCalculationBucketConfig  The number of buckets to use for the xAxis in the heatmap
   * @param yBuckets            $.heatmapCalculationBucketConfig  The number of buckets to use for the yAxis in the heatmap
   */
  HeatmapCalculationOptions(
    xBuckets          = null,
    yBuckets          = null,
  ):: {
    [if xBuckets            != null then 'xBuckets'           ]: xBuckets,
    [if yBuckets            != null then 'yBuckets'           ]: yBuckets,
  },

  /**
   * @param cellOptions         $.tableCellOptions
   * @param align               $.fieldTextAlignment
   * @param displayMode         $.tableCellDisplayMode        This field is deprecated in favor of using cellOptions
   * @param filterable          boolean
   * @param hidden              boolean
   * @param inspect             boolean
   * @param minWidth            number
   * @param width               number
   */
  TableFieldOptions(
    cellOptions,
    align             = $.fieldTextAlignment.Auto,
    displayMode       = null,
    filterable        = null,
    hidden            = null,
    inspect           = false,
    minWidth          = null,
    width             = null,
  ):: {
    align:              align,
    cellOptions:        cellOptions,
    [if displayMode         != null then 'displayMode'        ]: displayMode,
    [if filterable          != null then 'filterable'         ]: filterable,
    [if hidden              != null then 'hidden'             ]: hidden,
    inspect:            inspect,
    [if minWidth            != null then 'minWidth'           ]: minWidth,
    [if width               != null then 'width'              ]: width,
  },

  /**
   * User-defined value for a metric that triggers visual changes in a panel when this value is met or exceeded
   * They are used to conditionally style and color visualizations based on query results , and can be applied to most visualizations.
   *
   * @param color               string                        Represents the color of the visual change that will occur in the dashboard when the threshold value is met or exceeded.
   * @param value               number                        Value represents a specified metric for the threshold, which triggers a visual change in the dashboard when this value is met or exceeded.
   */
  Threshold(
   color,
   value             = null,
 ):: {
   color: color,
   value: null
 },

  /**
   * Thresholds configuration for a panel.
   *
   * @param mode                $.ThresholdsMode              Thresholds mode.
   * @param steps               Array<$.Threshold>            Must be sorted by 'value', first value is always -Infinity
   */
  ThresholdsConfig(
    mode,
    steps,
  ):: {
    mode:               mode,
    steps:              steps,

    addStep(step):: self {
      steps+: step,
    },
    addSteps(steps):: std.foldl(function(c, s) c.addStep(s), steps, self),
  },

  ////////////////////////////////////////////////////////////////////////////
  // Constants

  scaleDimensionMode:: {
    Linear::              'linear',
    Quad::                'quad',
  },
  scalarDimensionMode:: {
    Clamped::             'clamped',
    Mod::                 'mod',
  },
  textDimensionMode:: {
    Field::               'field',
    Fixed::               'fixed',
    Template::            'template',
  },
  frameGeometrySourceMode:: {
    Auto::                'auto',
    Coords::              'coords',
    Geohash::             'geohash',
    Lookup::              'lookup',
  },
  heatmapCalculationMode: {
    Count::               'count',
    Size::                'size',
  },
  heatmapCellLayout:: {
    Auto::                'auto',
    Greater::             'ge',
    Lower::               'le',
    Unknown::             'unknown',
  },
  logsSortOrder:: {
    Ascending::           'Ascending',
    Descending::          'Descending',
  },
  axisPlacement:: {
    Auto::                'auto',
    Bottom::              'bottom',
    Hidden::              'hidden',
    Left::                'left',
    Right::               'right',
    Top::                 'top',
  },
  axisColorMode:: {
    Series::              'series',
    Text::                'text',
  },
  visibilityMode:: {
    Always::              'always',
    Auto::                'auto',
    Never::               'never',
  },
  graphDrawStyle:: {
    Bars::                'bars',
    Line::                'line',
    Points::              'points',
  },
  graphTransform:: {
    Constant::            'constant',
    NegativeY::           'negative-Y',
  },
  lineInterpolation:: {
    Linear::              'linear',
    Smooth::              'smooth',
    StepAfter::           'stepAfter',
    StepBefore: 'stepBefore',
  },
  scaleDistribution:: {
    Linear::              'linear',
    Log::                 'log',
    Ordinal::             'ordinal',
    Symlog::              'symlog',
  },
  graphGradientMode:: {
    Hue::                 'hue',
    None::                'none',
    Opacity::             'opacity',
    Scheme::              'scheme',
  },
  stackingMode:: {
    None::                'none',
    Normal::              'normal',
    Percent::             'percent',
  },
  barAlignment:: {
    After::               1,
    Before::              -1,
    Center::              0,
  },
  scaleOrientation:: {
    Horizontal::          0,
    Vertical::            1,
  },
  scaleDirection:: {
    Down::                -1,
    Left::                -1,
    Right::               1,
    Up::                  1,
  },
  lineStyle:: {
    Solid::               'solid',
    Dash::                'dash',
    Dot::                 'dot',
    Square::              'square',
  },
  graphTresholdsStyle:: {
    Area::                'area',
    Dashed::              'dashed',
    DashedAndArea::       'dashed+area',
    Line::                'line',
    LineAndArea::         'line+area',
    Off::                 'off',
    Series::              'series',
  },
  legendPlacement:: {
    Bottom::              'bottom',
    Right::               'right',
  },
  legendDisplayMode:: {
    Hidden::              'hidden',
    List::                'list',
    Table::               'table',
  },
  vizOrientation:: {
    Auto::                'auto',
    Horizontal::          'horizontal',
    Vertical::            'vertical',
  },
  bigValueColorMode:: {
    Background::          'background',
    BackgroundSolid::     'background_solid',
    None::                'none',
    Value::               'value',
  },
  bigValueGraphMode:: {
    Area::                'area',
    Line::                'line',
    None::                'none',
  },
  bigValueJustifyMode:: {
    Auto::                'auto',
    Center::              'center',
  },
  bigValueTextMode:: {
    Auto::                'auto',
    Name::                'name',
    None::                'none',
    Value::               'value',
    ValueAndName::        'value_and_name',
  },
  fieldTextAlignment:: {
    Auto::                'auto',
    Left::                'left',
    Right::               'right',
    Center::              'center',
  },
  timelineValueAlignment:: {
    Center::              'center',
    Left::                'left',
    Right::               'right',
  },
  tooltipDisplayMode:: {
    Multi::               'multi',
    None::                'none',
    Single::              'single',
  },
  sortOrder:: {
    Ascending::           'asc',
    Descending::          'desc',
    None::                'none',
  },
  barGaugeDisplayMode:: {
    Basic::                'basic',
    Gradient::             'gradient',
    Lcd::                  'lcd',
  },
  barGaugeValueMode:: {
    Color::                'color',
    Hidden::               'hidden',
    Text::                 'text',
  },
  tableCellDisplayMode:: {
    Auto:::                 'auto',
    BasicGauge:::           'basic',
    ColorBackground:::      'color-background',
    ColorBackgroundSolid::: 'color-background-solid',
    ColorText:::            'color-text',
    Gauge:::                'gauge',
    GradientGauge:::        'gradient-gauge',
    Image:::                'image',
    JSONView:::             'json-view',
    LcdGauge:::             'lcd-gauge',
    Sparkline:::            'sparkline',
  },
  tableCellBackgroundDisplayMode:: {
    Basic::                 'basic',
    Gradient::              'gradient',
  },
  tableCellHeight:: {
    Large::                 'lg',
    Medium::                'md',
    Small::                 'sm',
  },
  timezone:: {
    Browser::               'browser',
    UTC::                   'utc',
  },
  variableFormatID:: {
    CSV::                   'csv',
    Date::                  'date',
    Distributed::           'distributed',
    DoubleQuote::           'doublequote',
    Glob::                  'glob',
    HTML::                  'html',
    JSON::                  'json',
    Lucene::                'lucene',
    PercentEncode::         'percentencode',
    Pipe::                  'pipe',
    QueryParam::            'queryparam',
    Raw::                   'raw',
    Regex::                 'regex',
    SQLString::             'sqlstring',
    SingleQuote::           'singlequote',
    Text::                  'text',
    UriEncode::             'uriencode',
  },
  logsDedupStrategy:: {
    Exact::                 'exact',
    None::                  'none',
    Numbers::               'numbers',
    Signature::             'signature',
  },
  comparisonOperation:: {
    EQ::                    'eq',
    GT::                    'gt',
    GTE::                   'gte',
    LT::                    'lt',
    LTE::                   'lte',
    NEQ::                   'neq',
  },

  fieldColorMode:: {
    Thresholds::             'thresholds',
    PaletteClassic::         'palette-classic',
    PaletteClassicByName::   'palette-classic-by-name',
    PaletteSaturated::       'palette-saturated',
    ContinuousGrYlRd::       'continuous-GrYlRd',
    ContinuousRdYlGr::       'continuous-RdYlGr',
    ContinuousBlYlRd::       'continuous-BlYlRd',
    ContinuousYlRd::         'continuous-YlRd',
    ContinuousBlPu::         'continuous-BlPu',
    ContinuousYlBl::         'continuous-YlBl',
    ContinuousBlues::        'continuous-blues',
    ContinuousReds::         'continuous-reds',
    ContinuousGreens::       'continuous-greens',
    ContinuousPurples::      'continuous-purples',
    Fixed::                  'fixed',
    Shades::                 'shades',
  },
  thresholdMode:: {
  Absolute::                 'absolute',
  Percentage::               'percentage',
  },

  matcher:: {
    Any::                    'anyMatch',                                         // checks children
    All::                    'allMatch',                                         // checks children
    Invert::                 'invertMatch',                                      // checks child
    Always::                 'alwaysMatch',
    Never::                  'neverMatch',
  },
  fieldMatcher:: {
    // Specific Types
    Numeric::                'numeric',
    Time::                   'time',                                             // Can be multiple times
    First::                  'first',
    FirstTimeField::         'firstTimeField',                                   // Only the first time field

    // With arguments
    ByType::                 'byType',
    ByName::                 'byName',
    ByNames::                'byNames',
    ByRegexp::               'byRegexp',
    ByRegexpOrNames::        'byRegexpOrNames',
    ByFrameRefID::           'byFrameRefID',
    ByValue::                'byValue',
    // ByIndex::             'byIndex',
    // ByLabel::             'byLabel',
  },
  frameMatcher:: {
    ByName::                 'byName',
    ByRefId::                'byRefId',
    ByIndex::                'byIndex',
  },
  valueMatcherID:: {
    Regex::                 'regex',
    IsNull::                'isNull',
    IsNotNull::             'isNotNull',
    Greater::               'greater',
    GreaterOrEqual::        'greaterOrEqual',
    Lower::                 'lower',
    LowerOrEqual::          'lowerOrEqual',
    Equal::                 'equal',
    NotEqual::              'notEqual',
    Between::               'between',
  },
  repeatDirection:: {
    Horizontal::            'h',
    Vertical::              'v',
  },

  alerts:: {
    evaluators:: {
      Above::               'gt',
      Below::               'lt',
      OutsideRange::        'outside_range',
      WithinRange::         'within_range',
      NoValue::             'no_value',
    },
    operators:: {
      And::                 'and',
      Or::                  'or',
    },
    reducers:: {
      Avg::                 'avg',
      Min::                 'min',
      Max::                 'max',
      Sum::                 'sum',
      Count::               'count',
      Last::                'last',
      Median::              'median',
      Diff::                'diff',
      DiffAbs::             'diff_abs',
      PercentDiff::         'percent_diff',
      PercentDiffAbs::      'percent_diff_abs',
      CountNonNull::        'count_non_null',
    },
    noDataModes::{
      Alerting:             'alerting',
      NoData:               'no_data',
      KeepLastState:        'keep_state',
      Ok:                   'ok',
    },
    executionErrorModes:: {
      Alerting:             'alerting',
      KeepLastState:        'keep_state',
    },
  },

  units:: {
    ////////////////////////////////////////////////
    // Misc
    Number::                      'none',
    String::                      'string',
    Short::                       'short',                        // Short
    Percent::                     'percent',                      // Percent (0 - 100)
    PercentUnit::                 'percentunit',                  // Percent (0.0 - 1.0))
    Hex0x::                       'hex0x',                        // Hexadecimal with 0x prefix
    Hex::                         'hex',                          // Hexadecimal
    Scientific::                  'sci',                          // Scientific notation
    Local::                       'locale',                       // Locale format

    ////////////////////////////////////////////////
    // Data
    Bits::                        'bits',                         // Bits (IEC)
    Bytes::                       'bytes',                        // Bytes (IEC)
    Kibibytes::                   'kbytes',                       // Kibibytes (IEC)
    Mebibytes::                   'mbytes',                       // Mebibytes (IEC)
    Gibibytes::                   'gbytes',                       // Gibibytes (IEC)
    Tebibytes::                   'tbytes',                       // Tebibytes (IEC)
    Pebibytes::                   'pbytes',                       // Pebibytes (IEC)

    BitsDec::                     'decbits',                      // Bits (DEC)
    BytesDec::                    'decbytes',                     // Bytes (DEC)
    Kilobytes::                   'deckbytes',                    // Kilobytes (DEC)
    Megabytes::                   'decmbytes',                    // Megabytes (DEC)
    Gigabytes::                   'decgbytes',                    // Gigabytes (DEC)
    Terabytes::                   'dectbytes',                    // Terabytes (DEC)
    Petabytes::                   'decpbytes',                    // Petabytes (DEC)

    ////////////////////////////////////////////////
    // Data Rate
    PacketPerSecond::             'pps',                          // Packets/Second

    BitsPerSecond::               'binbps',                       // Bits per second (IEC)
    KibibitsPerSecond::           'Kibits',                       // Kibibits per second (IEC)
    MebibitsPerSecond::           'Mibits',                       // Mebibits per second (IEC)
    GibibitsPerSeconds::          'Gibits',                       // Gibibits per second (IEC)
    TebibitsPerSeconds::          'Tibits',                       // Tebibits per second (IEC)
    PebibitsPerSeconds::          'Pibits',                       // Pebibits per second (IEC)

    BitsPerSecondDec::            'bps',                          // Bits per second (DEC)
    KilobitsPerSecond::           'Kbits',                        // Kilobits per second (DEC)
    MegabitsPerSeconds::          'Mbits',                        // Megabits per second (DEC)
    GigabitsPerSeconds::          'Gbits',                        // Gigabits per second (DEC)
    TerabitsPerSeconds::          'Tbits',                        // Terabits per second (DEC)
    PetabitsPerSeconds::          'Pbits',                        // Petabits per second (DEC)

    BytesPerSecond::              'binBps',                       // Bytes per second (IEC)
    KibibytesPerSecond::          'KiBs',                         // Kibibytes per second (IEC)
    MebibytesPerSeconds::         'MiBs',                         // Mebibytes per second (IEC)
    GibibytesPerSeconds::         'GiBs',                         // Gibibytes per second (IEC)
    TebibytesPerSeconds::         'TiBs',                         // Tebibytes per second (IEC)
    PebibytesPerSeconds::         'PiBs',                         // Pebibytes per second (IEC)

    BytesPerSecondDec::           'Bps',                          // Bytes per second (DEC)
    KilobytesPerSecond::          'KBs',                          // Kilobytes per second (DEC)
    MegabytesPerSeconds::         'MBs',                          // Megabytes per second (DEC)
    GigabytesPerSeconds::         'GBs',                          // Gigabytes per second (DEC)
    TerabytesPerSeconds::         'TBs',                          // Terabytes per second (DEC)
    PetabytesPerSeconds::         'PBs',                          // Petabytes per second (DEC)

    ////////////////////////////////////////////////
    // Date & Time
    DateTimeIso::                 'dateTimeAsIso',                // Date and time in ISO format
    DateTimeIsoNoDateIfToday::    'dateTimeAsIsoNoDateIfToday',   // Date and time in ISO format, no date if today
    DateTimeUS::                  'dateTimeAsUS',                 // Date and time in US format
    DateTimeUSNoDateIfToday::     'dateTimeAsUSNoDateIfToday',    // Date and time in US format, no date if today
    DateTimeLocal::               'dateTimeAsLocal',              // Date and time in local format
    DateTimeLocalNoDateIfToday::  'dateTimeAsLocalNoDateIfToday', // Date and time in local format, no date if today
    DateTimeAsSystem::            'dateTimeAsSystem',             // Date and time in system format
    DateTimeFromNow::             'dateTimeFromNow',              // Date and time from now

    ////////////////////////////////////////////////
    // Hash Rate
    HashesPerSecond::             'Hs',                           // Hashes per second
    KiloHashesPerSecond::         'KHs',                          // Kilo hashes per second
    MegaHashesPerSecond::         'MHs',                          // Mega hashes per second
    GigaHashesPerSecond::         'GHs',                          // Giga hashes per second
    TeraHashesPerSecond::         'THs',                          // Tera hashes per second
    PetaHashesPerSecond::         'PHs',                          // Peta hashes per second
    ExaHashesPerSecond::          'EHs',                          // Exa hashes per second

    ////////////////////////////////////////////////
    // Time
    Nanoseconds::                 'ns',                           // Nanoseconds
    Microseconds::                'µs',                           // Microseconds
    Milliseconds::                'ms',                           // Milliseconds
    Seconds::                     's',                            // Seconds
    Minutes::                     'm',                            // Minutes
    Hours::                       'h',                            // Hours
    Days::                        'd',                            // Days

    Hertz::                       'hertz',                        // Hertz (1/s)
    DurationMilliseconds::        'dtdurationms',                 // Duration in milliseconds
    DurationSeconds::             'dtdurations',                  // Duration in seconds
    DurationHMS::                 'dthms',                        // Duration (hh:mm:ss)
    DurationDHMS::                'dtdhms',                       // Duration (d hh:mm:ss)
    Timeticks::                   'timeticks',                    // Timeticks (s/100)
    ClockMilliseconds::           'clockms',                      // Clock in milliseconds
    ClockSeconds::                'clocks',                       // Clock in seconds

    ////////////////////////////////////////////////
    // Throughput
    CountsPerSecond::             'cps',                          // Counts per second
    OpsPerSecond::                'ops',                          // Operations per second
    RequestsPerSecond::           'reqps',                        // Requests per second
    ReadsPerSecond::              'rps',                          // Reads per second
    WritesPerSecond::             'wps',                          // Writes per second
    IOPerSecond::                 'iops',                         // I/O ops per second
    EventsPerSecond::             'eps',                          // Events per second
    MessagesPerSecond::           'mps',                          // Messages per second
    RecordsPerSecond::            'recps',                        // Records per second
    RowsPerSecond::               'rowsps',                       // Rows per second

    CountsPerMinute::             'cpm',                          // Counts per minute
    OpsPerMinute::                'opm',                          // Operations per minute
    RequestsPerMinute::           'reqpm',                        // Requests per minute
    ReadsPerMinute::              'rpm',                          // Reads per minute
    WritesPerMinute::             'wpm',                          // Writes per minute
    EventsPerMinute::             'epm',                          // Events per minute
    MessagesPerMinute::           'mpm',                          // Messages per minute
    RecordsPerMinute::            'recpm',                        // Records per minute
    RowsPerMinute::               'rowspm',                       // Rows per minute

    ////////////////////////////////////////////////
    // Boolean
    TrueFalse::                   'bool',                         // True / False
    YesNo::                       'bool_yes_no',                  // Yes / No
    OnOff::                       'bool_on_off',                  // On / Off
  }
}
