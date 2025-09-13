#!/bin/sh
set -eu

WORKFLOW_DIR="./workflows"

if [ -d "$WORKFLOW_DIR" ]; then
  if command -v conftest >/dev/null 2>&1; then
    echo "Running Rego policy checks via conftest..."
    conftest test -p policy/yaml "$WORKFLOW_DIR"
  else
    echo "conftest not found locally; skipping Rego policy check."
  fi
fi

if [ -d "$WORKFLOW_DIR" ]; then
  echo "Running regex-based CEL/YAML hygiene checks..."

  # Check for unquoted CEL expressions
  BAD_CEL=$(grep -R --include='*.yaml' -n '\${[^}]*}' "$WORKFLOW_DIR" | grep -v ":'\${" || true)
  if [ -n "${BAD_CEL:-}" ]; then
    echo "❌ Found unquoted CEL expressions:"
    echo "$BAD_CEL"
    exit 1
  fi

  # Check for nested quotes in CEL
  NESTED=$(grep -R --include='*.yaml' -n "'\${[^}]*\"[^}]*}'" "$WORKFLOW_DIR" || true)
  if [ -n "${NESTED:-}" ]; then
    echo "❌ Found nested quotes inside CEL:"
    echo "$NESTED"
    exit 1
  fi

  # Check for disallowed functions
  BAD_FUNCS=$(grep -R --include='*.yaml' -n -E 'text\(|sys\.guid\b|workflow\.timestamp\b' "$WORKFLOW_DIR" || true)
  if [ -n "${BAD_FUNCS:-}" ]; then
    echo "❌ Found unsupported functions in YAML:"
    echo "$BAD_FUNCS"
    exit 1
  fi

  echo "✅ YAML/CEL hygiene checks passed."
fi
