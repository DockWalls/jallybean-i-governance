package policy.yaml.cel_forbidden_functions

forbidden_functions := {"getenv", "env", "printf", "now"}

allowed_exceptions := {
  "workflows/crisis_escalation.yaml": {"env", "now"},
  "workflows/incident_response.yaml": {"now"},
  "workflows/identity_bootstrap.yaml": {"getenv"}
}

deny contains msg if {
  some path, val
  walk(input, [path, val])
  is_string(val)
  some i
  f := forbidden_functions[i]
  contains(lower(val), f)
  not exception(input._filepath, f)
  msg := sprintf("Forbidden CEL function '%s' used at %v", [f, path])
}

exception(path, func) if {
  allowed := object.get(allowed_exceptions, path, set())
  func in allowed
}