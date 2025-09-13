package yaml

forbidden_functions = {"sys.guid", "text(", "workflow.timestamp"}

deny[msg] {
  val := input.content[_].spec.steps[_].args[_]
  some f
  fn := forbidden_functions[f]
  contains(val, fn)
  msg := sprintf("Forbidden CEL function '%s' used", [fn])
}