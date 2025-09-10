#!/bin/bash
set -e

echo "Checking YAML structure..."
yamllint ../workflows/*.yaml

echo "Checking Terraform validity..."
terraform validate

echo "Checking for forbidden functions..."
if grep -R "sys.guid" ../workflows; then
  echo "sys.guid found. Replace with external UUID generator."
  exit 1
fi
if grep -R "text(" ../workflows; then
  echo "text() found. Use json.encode() instead."
  exit 1
fi
if grep -R "workflow.timestamp" ../workflows; then
  echo "workflow.timestamp found. Use sys.now() instead."
  exit 1
fi

echo "All Jallybean compliance checks passed."
