package cel_hygiene

default deny = []

# Walk all YAML scalar values and apply regex checks
deny[msg] {
  some p, v
  walk(input, [p, v])
  is_string(v)
  re_match("\\$\\{[^}]*\\}", v)
  not re_match("^'\\$\\{[^}]*\\}'$", v)
  msg := sprintf("CEL must be wrapped in single quotes at path %v: %v", [p, v])
}

deny[msg] {
  some p, v
  walk(input, [p, v])
  is_string(v)
  re_match("'\\$\\{[^}]*\"[^}]*\\}'", v)
  msg := sprintf("Nested quotes inside CEL are not allowed at path %v", [p])
}

deny[msg] {
  some p, v
  walk(input, [p, v])
  is_object(v)
  v["steps"]
  not is_array(v["steps"])
  msg := sprintf("steps must be a list at path %v", [p])
}

deny[msg] {
  some p, v
  walk(input, [p, v])
  is_string(v)
  re_match("(^|[^a-zA-Z0-9_])text\\(", v)
  msg := sprintf("text() is unsupported. Use json.encode() at path %v", [p])
}

deny[msg] {
  some p, v
  walk(input, [p, v])
  is_string(v)
  re_match("(^|[^a-zA-Z0-9_])sys\\.guid\\b", v)
  msg := sprintf("sys.guid is disallowed. Use external UUID generation at path %v", [p])
}

deny[msg] {
  some p, v
  walk(input, [p, v])
  is_string(v)
  re_match("(^|[^a-zA-Z0-9_])workflow\\.timestamp\\b", v)
  msg := sprintf("workflow.timestamp is unsupported. Use sys.now() at path %v", [p])
}
