#!/bin/sh
set -eu

if [ -d "./workflows" ]; then
  if command -v conftest >/dev/null 2>&1; then
    conftest test -p policy/yaml ./workflows
  else
    echo "conftest not found locally; YAML/CEL policy will run in Cloud Build."
  fi
fi

if [ -d "./workflows" ]; then
  BAD_CEL=$(grep -R --include='*.yaml' -n "\${[^}]*}" ./workflows | grep -v ":'\${" || true)
  if [ -n "${BAD_CEL:-}" ]; then
    echo "Found unquoted CEL expressions:"
    echo "$BAD_CEL"
    exit 1
  fi

  NESTED=$(grep -R --include='*.yaml' -n "'\${[^}]*\"[^}]*}'" ./workflows || true)
  if [ -n "${NESTED:-}" ]; then
    echo "Found nested quotes inside CEL:"
    echo "$NESTED"
    exit 1
  fi

  BAD_FUNCS=$(grep -R --include='*.yaml' -n -E "text\(|sys\.guid\b|workflow\.timestamp\b" ./workflows || true)
  if [ -n "${BAD_FUNCS:-}" ]; then
    echo "Found unsupported functions in YAML:"
    echo "$BAD_FUNCS"
    exit 1
  fi
fi

echo "YAML/CEL checks passed."
