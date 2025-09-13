package main

deny contains msg if {
  input.kind == "Expression"
  expr := input.expr
  regex.match(`(?i)\b(exec|system|os\.|net\.|http\.)\b`, expr)
  msg := sprintf("Expression '%s' contains disallowed function or package", [expr])
}

deny contains msg if {
  input.kind == "Expression"
  expr := input.expr
  regex.match(`==`, expr)
  not regex.match(`===`, expr)
  msg := sprintf("Use of '==' is discouraged in expression: %s", [expr])
}

deny contains msg if {
  input.kind == "Expression"
  expr := input.expr
  regex.match(`[^a-zA-Z0-9_]input[^a-zA-Z0-9_]`, expr)
  msg := sprintf("Avoid direct use of 'input' as a variable in: %s", [expr])
}

deny contains msg if {
  input.kind == "Expression"
  expr := input.expr
  regex.match(`(?i)(password|secret|api[_-]?key|token)[^a-zA-Z0-9]?`, expr)
  msg := sprintf("Potential secret detected in expression: %s", [expr])
}

deny contains msg if {
  input.kind == "Expression"
  expr := input.expr
  regex.match(`[\*/%]{2,}`, expr)
  msg := sprintf("Possibly dangerous math operation found in: %s", [expr])
}

deny contains msg if {
  input.kind == "Expression"
  expr := input.expr
  regex.match(`(?i)env\.get|sys\.getenv|os\.environ`, expr)
  msg := sprintf("Access to environment variables is disallowed in: %s", [expr])
}
