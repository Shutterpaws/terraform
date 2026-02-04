# Pre-commit Hooks Setup

This repository uses pre-commit hooks to maintain code quality and consistency for Terraform Infrastructure as Code.

## Prerequisites

Before installing pre-commit hooks, ensure you have:

- **Python 3.8+** - Required for pre-commit itself
- **Terraform 1.0+** - Required for terraform fmt and validate
- **TFLint** - Required for terraform linting (see [TFLint installation](https://github.com/terraform-linters/tflint))
  - Must be available on your PATH (verify with `tflint --version`)

## Installation

1. Install `pre-commit`:

   ```bash
   pip install pre-commit
   ```

2. Install the git hooks:

   ```bash
   pre-commit install
   ```

3. (Optional) Run all hooks on all files to check the current state:
   ```bash
   pre-commit run --all-files
   ```

## What Checks Are Included

- **Trailing whitespace**: Removes trailing whitespace from files
- **End of file fixer**: Ensures files end with a newline
- **YAML checker**: Validates YAML syntax
- **JSON checker**: Validates JSON syntax
- **TOML checker**: Validates TOML syntax
- **Merge conflict checker**: Detects merge conflict markers
- **Terraform format**: Auto-formats Terraform code with `terraform fmt`
- **Terraform validate**: Validates Terraform configuration syntax
- **Terraform linting**: Checks Terraform code with TFLint for best practices
- **Codespell**: Checks for common spelling mistakes
- **YAML linting**: Checks YAML style and formatting

## Manual Usage

To run pre-commit checks:

```bash
# Run on staged files only
pre-commit run

# Run on all files
pre-commit run --all-files

# Run a specific hook
pre-commit run terraform_fmt --all-files
pre-commit run terraform_validate --all-files
pre-commit run terraform_tflint --all-files

# Update hooks to latest versions
pre-commit autoupdate
```

## Configuration Files

- `.pre-commit-config.yaml` - Main pre-commit configuration
- `.tflintrc` - TFLint configuration for Terraform linting rules
- `.codespellrc` - Codespell configuration for spell checking

## GitHub Actions Automation

The repository includes a GitHub Actions workflow (`.github/workflows/pre-commit.yml`) that automatically runs pre-commit checks on every pull request and push to the main branch. The workflow can automatically commit and push formatting fixes to PR branches.

### Security Considerations

The workflow uses `contents: write` permission to enable automatic commits of pre-commit fixes. This design includes several security mitigations:

- **Same-repository check**: Auto-fixes only run on PRs from the same repository (`github.event.pull_request.head.repo.full_name == github.repository`). PRs from forks cannot trigger auto-fixes.
- **CI skip flag**: Commits include `[skip ci]` to prevent infinite workflow loops
- **Limited scope**: Only changes from pre-commit hooks are committed—no other modifications
- **Visibility**: All changes are committed with a clear message ("chore: apply pre-commit fixes") and visible in the PR

This approach balances automation with security. If your team prefers manual review of all changes, you can disable the auto-commit functionality by removing the "Commit and push fixes" step from the workflow.

## Troubleshooting

If a hook fails:

1. Review the error message
2. Fix the issues manually or let auto-fixing hooks correct them (e.g., `terraform fmt` will auto-fix formatting)
3. Stage the fixed files and commit again

### Common Issues

**TFLint not found:**
```bash
# Install TFLint (download script, review it, then run)
curl -o install_tflint.sh https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh
chmod +x install_tflint.sh
./install_tflint.sh
# Or via Homebrew on macOS
brew install tflint
```

**Terraform validate fails for workspace-specific configs:**
If your Terraform configuration requires variables or specific workspace settings, you may need to modify the pre-commit configuration to skip the validate hook or adjust it as needed.
