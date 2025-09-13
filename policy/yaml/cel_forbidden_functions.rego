package yaml

allowed_exceptions = {
  "workflows/crisis_escalation.yaml": {"text("},
  "workflows/incident_response.yaml": {"workflow.timestamp"},
  "workflows/identity_bootstrap.yaml": {"sys.guid"}
}

forbidden_functions = {"sys.guid", "text(", "workflow.timestamp"}

deny[msg] {
  # Get the set of exceptions for the current file, or an empty set if none
  exceptions := object.get(allowed_exceptions, input.path, set())

  # Get the set of forbidden functions that are not in the exceptions
  violation_functions := forbidden_functions - exceptions

  # Iterate over the steps and args
  val := input.content[_].spec.steps[_].args[_]

  # Iterate over the violation functions
  some f
  fn := violation_functions[f]

  # Check if the function is used
  contains(val, fn)

  # Create the error message
  msg := sprintf("Forbidden CEL function '%s' used in %s", [fn, input.path])
}