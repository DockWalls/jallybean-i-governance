package terraform.plan

deny contains msg if {
  some change in input.resource_changes
  startswith(change.type, "google_")
  not change.change.after.labels.environment
  msg := sprintf("%s missing labels.environment", [change.address])
}