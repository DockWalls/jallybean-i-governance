#!/bin/bash
set -euo pipefail

# CONFIGURATION
REPO="DockWalls/jallybean-i-governance"
BRANCH="main"
STATUS_CHECK="pr-checks (ivory-mountain-470414-k1)"

# Apply branch protection
gh api --method PUT "/repos/$REPO/branches/$BRANCH/protection" \
  -H "Accept: application/vnd.github+json" \
  --input - <<EOF
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["$STATUS_CHECK"]
  },
  "enforce_admins": null,
  "required_pull_request_reviews": null,
  "restrictions": null
}
EOF

echo "✅ Branch protection applied to '$BRANCH' with required status check: '$STATUS_CHECK'"