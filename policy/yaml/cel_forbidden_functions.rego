package policy.yaml.cel_forbidden_functions

# Forbidden CEL function tokens (lowercased substring match)
forbidden := ["env", "now", "getenv", "printf"]

# Whitelist specific functions in specific files (sets per file)
allowed_exceptions := {
  "workflows/crisis_escalation.yaml": {"env", "now"},
}

deny[msg] {
  # Walk the entire input doc and look at string values
  some path, val
  walk(input, [path, val])
  is_string(val)

  # Find any forbidden token in the string (case-insensitive)
  some i
  f := forbidden[i]
  contains(lower(val), f)

  # Skip if explicitly allowed for this file
  not exception(input.path, f)

  msg := sprintf("Forbidden CEL function '%s' used at %v", [f, path])
}

exception(path, func) {
  allowed := object.get(allowed_exceptions, path, set())
  func in allowed
}