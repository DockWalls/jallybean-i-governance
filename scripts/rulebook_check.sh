#!/bin/bash
set -euo pipefail

echo "[rulebook_check] Starting Jallybean Compliance Rulebook checks..."

# ==============================
# 1. Terraform Formatting Check
# ==============================
echo "[rulebook_check] Checking Terraform formatting..."
if ! terraform fmt -check -recursive; then
  echo "Terraform files are not properly formatted."
  echo "Run 'terraform fmt -recursive' locally to fix formatting issues."
  exit 1
fi
echo "Terraform formatting check passed."

# ==============================
# 2. Terraform Validate
# ==============================
echo "[rulebook_check] Validating Terraform configuration..."
if ! terraform validate; then
  echo "Terraform validation failed."
  exit 1
fi
echo "Terraform validation passed."

# ==============================
# 3. Resource Naming Conventions
#    (BusyBox-safe: use find + xargs, not --include/--line-number)
# ==============================
echo "[rulebook_check] Checking resource naming conventions..."
# Search all .tf files for resource lines, then flag any with forbidden substrings
if find . -type f -name '*.tf' -print0 \
  | xargs -0 grep -nE 'resource[[:space:]]+"[^"]+"' 2>/dev/null \
  | grep -qE '(_test|forbidden_)'
then
  echo "Forbidden resource names found (contains '_test' or 'forbidden_')."
  exit 1
fi
echo "Resource naming conventions passed."

# ==============================
# 4. Required Tags on Google Resources (advisory)
#    Heuristic: if a file has a google_* resource but nowhere contains 'labels'
#    in that file, warn. (Set exit 1 to enforce strictly.)
# ==============================
echo "[rulebook_check] Checking for Google resource labels (environment)..."
missing_labels=0
while IFS= read -r -d '' file; do
  if grep -q 'resource "google_' "$file"; then
    if ! grep -q 'labels' "$file"; then
      echo "Warning: $file may be missing required 'labels { environment = ... }'."
      missing_labels=1
    fi
  fi
done < <(find . -type f -name '*.tf' -print0)

if [ "$missing_labels" -eq 0 ]; then
  echo "Resource label policy check passed."
fi
# To enforce strictly, uncomment the next two lines:
# if [ "$missing_labels" -ne 0 ]; then exit 1; fi

# ==============================
# 5. YAML Lint
#    Make document start '---' required and treat violations as errors.
# ==============================
echo "[rulebook_check] Running YAML lint..."
yamllint -d "{extends: default, rules: {document-start: {present: true, level: error}}}" ./workflows/*.yaml

echo "[rulebook_check] All compliance checks passed."
