package metric_kinds

default deny = []

deny[msg] {
  some i
  rc := input.resource_changes[i]
  after := rc.change.after
  after.metricKind
  not allowed(after.metricKind)
  msg := sprintf("metricKind must be DELTA or CUMULATIVE for %s.%s (found %v)", [rc.type, rc.name, after.metricKind])
}

allowed(k) { k == "DELTA" }
allowed(k) { k == "CUMULATIVE" }
