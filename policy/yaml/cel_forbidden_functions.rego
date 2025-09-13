package policy.yaml.cel_forbidden_functions

default deny = []

# Define a set of forbidden function names
forbidden_functions := {"getenv", "env", "printf", "now"}

# Return a message if input.function is forbidden
deny[msg] {
  func := input.function
  forbidden_functions[func]
  msg := sprintf("forbidden function used: %v", [func])
}