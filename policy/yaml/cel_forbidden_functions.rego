package yaml

deny[msg] {
  input.content[_].spec.steps[_].args[_] == val
  forbidden := ["sys.guid", "text(", "workflow.timestamp"]
  some f
  forbidden[f]
  contains(val, f)
  msg := sprintf("Forbidden CEL function used: %s", [f])
}