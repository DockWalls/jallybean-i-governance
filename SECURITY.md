# Security Policy

## Personal Access Tokens

- **Scope**: `repo`, `workflow`, `write:packages`
- **Rotation**: Every 90 days
- **Storage**: Never committed; stored via Git credential helper
- **Usage**: Only for CI/CD authentication; never used interactively