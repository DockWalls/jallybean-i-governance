package cel_quotes

deny contains msg if {
  some p, v
  walk(input, [p, v])
  is_string(v)
  regex.match("\\$\\{[^}]*\\}", v)
  not regex.match("^'\\$\\{[^}]*\\}'$", v)
  msg := sprintf("CEL must be wrapped in single quotes at path %v: %v", [p, v])
}
