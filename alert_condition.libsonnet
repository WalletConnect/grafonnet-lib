{
  /**
   * Returns a new condition of alert of graph panel.
   * Currently the only condition type that exists is a Query condition
   * that allows to specify a query letter, time range and an aggregation function.
   *
   * @name alertCondition.new
   *
   * @param evaluatorParams Value of threshold
   * @param evaluatorType Type of threshold
   * @param operatorType Operator between conditions
   * @param queryRefId The letter defines what query to execute from the Metrics tab
   * @param queryTimeStart Begging of time range
   * @param queryTimeEnd End of time range
   * @param reducerParams Params of an aggregation function
   * @param reducerType Name of an aggregation function
   *
   * @return A json that represents a condition of alert
   */
  new(
    evaluatorParams = [],
    evaluatorType   = $.evaluators.Above,
    operatorType    = $.operators.And,
    queryRefId      = 'A',
    queryTimeStart  = '5m',
    queryTimeEnd    = 'now',
    reducerParams   = [],
    reducerType     = $.reducers.Avg,
  )::
    {
      evaluator: {
        params: if std.type(evaluatorParams) == 'array' then evaluatorParams else [evaluatorParams],
        type: evaluatorType,
      },
      operator: {
        type: operatorType,
      },
      query: {
        params: [queryRefId, queryTimeStart, queryTimeEnd],
      },
      reducer: {
        params: if std.type(reducerParams) == 'array' then reducerParams else [reducerParams],
        type: reducerType,
      },
      type: 'query',
    },


  evaluators:: {
    Above::           'gt',
    Below::           'lt',
  },

  operators:: {
    And::             'and',
    Or::              'or',
  },

  reducers:: {
    Avg::             'avg',
    Min::             'min',
    Max::             'max',
    Sum::             'sum',
    Count::           'count',
    Last::            'last',
    Median::          'median',
    Diff::            'diff',
    DiffAbs::         'diff_abs',
    PercentDiff::     'percent_diff',
    PercentDiffAbs::  'percent_diff_abs',
    CountNonNull::    'count_non_null',
  }
}
