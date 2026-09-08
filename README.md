# Grafonnet

Jsonnet libraries for writing Grafana dashboards as code.

## `slo/` — SLO burn-rate alerting

Multiwindow multi-burn-rate SLO alerting (Google SRE Workbook, approach 6) as reusable
Jsonnet: a tier table, the Grafana rule builder, and the two panels that show how fast an
error budget is being spent. Self-tested with promtool in CI.

See [`slo/README.md`](slo/README.md).
