package policy.yaml.cel_forbidden_functions

# Forbidden CEL functions
forbidden_functions := {"getenv", "env", "printf", "now"}

# Scoped exceptions: allow certain functions in specific files
allowed_exceptions := {
  "workflows/crisis_escalation.yaml": {"printf"},
  "workflows/incident_response.yaml": {"now"},
  "workflows/identity_bootstrap.yaml": {"getenv"}
}

# Deny if function is forbidden and not explicitly allowed in this file
deny[msg] {
  func := input.function
  path := input.path

  func in forbidden_functions
  not allowed_exceptions[path][func]

  msg := sprintf("forbidden function '%s' used in %s", [func, path])
}