#!/bin/bash
set -euo pipefail

# CONFIGURATION
REPO="DockWalls/jallybean-i-governance"  # Replace with your actual org/repo
BRANCH="main"
STATUS_CHECK="Cloud Build"               # Replace with your actual Cloud Build trigger name

# Apply branch protection
gh api --method PUT "/repos/$REPO/branches/$BRANCH/protection" \
  -H "Accept: application/vnd.github+json" \
  --input - <<EOF
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["$STATUS_CHECK"]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true
  },
  "restrictions": null
}
EOF

echo "✅ Branch protection applied to '$BRANCH' with required status check: '$STATUS_CHECK'"