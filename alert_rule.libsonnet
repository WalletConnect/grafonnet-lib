{
  /**
   * Grafana Unified Alerting - Alert Rule
   * Compatible with Grafana v10.4+
   *
   * This module creates alert rules in the new Unified Alerting format.
   * Legacy panel-based alerts are no longer supported in Grafana 10+.
   *
   * @name alertRule.new
   *
   * @param name The name of the alert rule
   * @param folder_uid UID of the folder to store the alert
   * @param rule_group Name of the rule group
   * @param datasource_uid UID of the datasource
   * @param expr The PromQL/SQL expression for the query
   * @param condition The reduce function: avg, sum, last, min, max, count
   * @param threshold Threshold value for alerting
   * @param op Operator: gt (greater than), lt (less than), eq (equal)
   * @param for_duration Duration the condition must be true before firing
   * @param interval_seconds Evaluation interval in seconds
   * @param labels Additional labels for the alert
   * @param annotations Annotations (summary, description)
   * @param no_data_state State when no data: NoData, Alerting, OK
   * @param exec_err_state State on execution error: Error, Alerting, OK
   *
   * @return A json that represents a Grafana Unified Alert Rule
   */

  // Comparison operators
  operators:: {
    GreaterThan: 'gt',
    LessThan: 'lt',
    Equal: 'eq',
    NotEqual: 'neq',
    GreaterOrEqual: 'gte',
    LessOrEqual: 'lte',
    WithinRange: 'within_range',
    OutsideRange: 'outside_range',
  },

  // Reducer functions
  reducers:: {
    Avg: 'mean',
    Min: 'min',
    Max: 'max',
    Sum: 'sum',
    Count: 'count',
    Last: 'last',
  },

  // No data state
  noDataStates:: {
    NoData: 'NoData',
    Alerting: 'Alerting',
    OK: 'OK',
  },

  // Execution error state
  execErrStates:: {
    Error: 'Error',
    Alerting: 'Alerting',
    OK: 'OK',
  },

  /**
   * Creates a new unified alert rule.
   */
  new(
    name,
    folder_uid,
    rule_group,
    datasource_uid,
    datasource_type = 'prometheus',
    expr,
    condition = $.reducers.Avg,
    threshold,
    op = $.operators.GreaterThan,
    for_duration = '5m',
    interval_seconds = 60,
    labels = {},
    annotations = {},
    no_data_state = $.noDataStates.NoData,
    exec_err_state = $.execErrStates.Error,
    ref_id = 'A',
  ):: {
    local reduce_ref = 'B',
    local threshold_ref = 'C',

    name: name,
    interval_seconds: interval_seconds,
    rule_group: rule_group,
    folder_uid: folder_uid,
    for_duration: for_duration,
    no_data_state: no_data_state,
    exec_err_state: exec_err_state,
    labels: labels,
    annotations: annotations,

    // Data queries and conditions
    data: [
      // Query data
      {
        refId: ref_id,
        queryType: '',
        relativeTimeRange: {
          from: 600,
          to: 0,
        },
        datasourceUid: datasource_uid,
        model: {
          refId: ref_id,
          expr: expr,
          [if datasource_type == 'prometheus' then 'instant']: false,
          [if datasource_type == 'prometheus' then 'range']: true,
          [if datasource_type == 'prometheus' then 'interval']: '',
          [if datasource_type == 'prometheus' then 'legendFormat']: '',
          [if datasource_type == 'cloudwatch' then 'queryMode']: 'Metrics',
        },
      },
      // Reduce expression
      {
        refId: reduce_ref,
        queryType: '',
        relativeTimeRange: {
          from: 0,
          to: 0,
        },
        datasourceUid: '__expr__',
        model: {
          refId: reduce_ref,
          type: 'reduce',
          datasource: {
            type: '__expr__',
            uid: '__expr__',
          },
          expression: ref_id,
          reducer: condition,
          conditions: [
            {
              type: 'query',
              evaluator: {
                type: op,
                params: [],
              },
              operator: {
                type: 'and',
              },
              query: {
                params: [reduce_ref],
              },
              reducer: {
                type: 'last',
                params: [],
              },
            },
          ],
        },
      },
      // Threshold expression
      {
        refId: threshold_ref,
        queryType: '',
        relativeTimeRange: {
          from: 0,
          to: 0,
        },
        datasourceUid: '__expr__',
        model: {
          refId: threshold_ref,
          type: 'threshold',
          datasource: {
            type: '__expr__',
            uid: '__expr__',
          },
          expression: reduce_ref,
          conditions: [
            {
              type: 'query',
              evaluator: {
                type: op,
                params: [threshold],
              },
              operator: {
                type: 'and',
              },
              query: {
                params: [],
              },
              reducer: {
                type: 'last',
                params: [],
              },
            },
          ],
        },
      },
    ],

    // The condition references the threshold expression
    condition: threshold_ref,
  },

  /**
   * Creates a new rule group containing multiple alert rules.
   */
  ruleGroup(
    name,
    folder_uid,
    interval_seconds = 60,
    rules = [],
  ):: {
    name: name,
    folder_uid: folder_uid,
    interval_seconds: interval_seconds,
    rules: rules,
  },

  /**
   * Creates an alert rule for Prometheus datasource.
   */
  prometheus(
    name,
    folder_uid,
    rule_group,
    datasource_uid,
    expr,
    condition = $.reducers.Avg,
    threshold,
    op = $.operators.GreaterThan,
    for_duration = '5m',
    interval_seconds = 60,
    labels = {},
    annotations = {},
    no_data_state = $.noDataStates.NoData,
    exec_err_state = $.execErrStates.Error,
  ):: $.new(
    name = name,
    folder_uid = folder_uid,
    rule_group = rule_group,
    datasource_uid = datasource_uid,
    datasource_type = 'prometheus',
    expr = expr,
    condition = condition,
    threshold = threshold,
    op = op,
    for_duration = for_duration,
    interval_seconds = interval_seconds,
    labels = labels,
    annotations = annotations,
    no_data_state = no_data_state,
    exec_err_state = exec_err_state,
  ),

  /**
   * Creates an alert rule for CloudWatch datasource.
   */
  cloudwatch(
    name,
    folder_uid,
    rule_group,
    datasource_uid,
    expr,
    condition = $.reducers.Avg,
    threshold,
    op = $.operators.GreaterThan,
    for_duration = '5m',
    interval_seconds = 60,
    labels = {},
    annotations = {},
    no_data_state = $.noDataStates.NoData,
    exec_err_state = $.execErrStates.Error,
  ):: $.new(
    name = name,
    folder_uid = folder_uid,
    rule_group = rule_group,
    datasource_uid = datasource_uid,
    datasource_type = 'cloudwatch',
    expr = expr,
    condition = condition,
    threshold = threshold,
    op = op,
    for_duration = for_duration,
    interval_seconds = interval_seconds,
    labels = labels,
    annotations = annotations,
    no_data_state = no_data_state,
    exec_err_state = exec_err_state,
  ),
}
