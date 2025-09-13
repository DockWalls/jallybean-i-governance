package metric_kinds

# Allowed metric kinds
valid_kinds := {"GAUGE", "DELTA", "CUMULATIVE"}

deny contains msg if {
  some r
  input.resource_changes[r].change.after.metric.kind
  kind := input.resource_changes[r].change.after.metric.kind
  not valid_kinds[kind]
  msg := sprintf("Invalid metric.kind '%s' in resource %s. Allowed kinds: %v", [kind, r, valid_kinds])
}
