local fieldConfig = import '../field_config.libsonnet';

{
  _new(
    legend  = null,
    tooltip = $.tooltipModes.Single,
  ):: {
    fieldConfig: fieldConfig.new(),
    options: {
      [if legend  != null then 'legend' ]:  legend,
      [if tooltip != null then 'tooltip']:  tooltip,
    },

    addOverride(override)::                             $.addOverride       (self, override),
    addOverrides(overrides)::                           $.addOverrides      (self, overrides),
  },

  addOverride(_self, override):: _self {
    fieldConfig+: {
      overrides+: [override],
    }
  },
  addOverrides(_self, overrides):: std.foldl(function(p, s) p.addOverride(s), overrides, _self),

  GraphFieldConfig:: {
    drawStyle:         $.graphDrawStyle.Line,
    lineInterpolation: $.lineInterpolation.Linear,
    lineWidth:         1,
    fillOpacity:       0,
    gradientMode:      $.graphGradientMode.None,
    barAlignment:      $.barAlignment.Center,
    stacking:          {
      mode:   $.stackingMode.None,
      group:  'A',
    },
    axisGridShow:      true,
    axisCenteredZero:  false,
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
  LineStyle:: {
    Solid::               'solid',
    Dash::                'dash',
    Dot::                 'dot',
    Square::              'square',
  },
  graphTresholdsStyleMode:: {
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
}
