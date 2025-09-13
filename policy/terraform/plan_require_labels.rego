package terraform.plan

default deny = []

deny[reason] {
  rc := input.resource_changes[_]
  startswith(rc.type, "google_")
  lbls := rc.change.after.labels
  not lbls.environment
  reason := sprintf("%s missing labels.environment", [rc.address])
}
