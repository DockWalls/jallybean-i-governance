package outputs_hint

deny contains msg if {
  input.outputs
  not input.outputs.trace_id
  msg := "outputs.trace_id is recommended for audit logs"
}

deny contains msg if {
  input.outputs
  not input.outputs.timestamp
  msg := "outputs.timestamp is recommended for audit logs"
}

deny contains msg if {
  input.outputs
  not input.outputs.event
  msg := "outputs.event is recommended for audit logs"
}

deny contains msg if {
  input.outputs
  not input.outputs.decision
  msg := "outputs.decision is recommended for audit logs"
}

deny contains msg if {
  input.outputs
  not input.outputs.ledger
  msg := "outputs.ledger is recommended for audit logs"
}

