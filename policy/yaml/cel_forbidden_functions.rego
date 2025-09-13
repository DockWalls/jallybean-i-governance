package policy.yaml.cel_forbidden_functions

forbidden_functions := {"getenv", "env", "printf", "now"}

deny[msg] {
    some path, value
    walk(input, [path, value])
    is_string(value)
    some f
    fn := forbidden_functions[f]
    contains(value, fn)
    msg := sprintf("Forbidden CEL function '%s' used at %v", [fn, path])
}