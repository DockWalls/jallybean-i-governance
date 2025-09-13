package yaml

allowed_exceptions = {
  "workflows/crisis_escalation.yaml": ["text("],
  "workflows/incident_response.yaml": ["workflow.timestamp"],
  "workflows/identity_bootstrap.yaml": ["sys.guid"]
}

forbidden_functions = ["sys.guid", "text(", "workflow.timestamp"]

deny[msg] {
  # Check if the input is a workflow file
  endswith(input.path, ".yaml")

  # Get the list of allowed exceptions for the current file
  exceptions := object.get(allowed_exceptions, input.path, [])

  # Iterate over the steps and args
  val := input.content[_].spec.steps[_].args[_]

  # Iterate over the forbidden functions
  some f
  fn := forbidden_functions[f]

  # Check if the function is forbidden and not in the exceptions list
  contains(val, fn)
  not exceptions[fn]

  # Create the error message
  msg := sprintf("Forbidden CEL function '%s' used in %s", [fn, input.path])
}