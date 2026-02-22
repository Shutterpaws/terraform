# Copilot Instructions for Terraform Repository

## Repository Overview

This is a Terraform Infrastructure as Code (IaC) repository for managing Cloudflare infrastructure. The repository uses Terraform Cloud as a remote backend for state management.

**Key Facts:**
- **Purpose:** Manage Cloudflare DNS/CDN infrastructure
- **Backend:** Terraform Cloud (app.terraform.io)
- **Organization:** Shutterpaws
- **Workspace:** terraform
- **Provider:** Cloudflare provider version ~> 5.x

## Repository Structure

```
.
├── .github/              # GitHub configuration (this file)
├── .terraform/           # Local provider plugins (not committed)
├── .terraform.lock.hcl   # Provider version lock file (SHOULD be committed)
├── .gitignore           # Git ignore patterns for Terraform
├── README.md            # Project documentation
├── provider.tf          # Terraform and provider configuration
├── main.tf              # Provider instance configuration
├── vars.tf              # Variable definitions
└── *.tfvars             # Variable values (not committed - sensitive)
```

## Prerequisites & Setup

### Installing Terraform

```bash
# Download and install Terraform (use latest stable version)
wget https://releases.hashicorp.com/terraform/1.7.0/terraform_1.7.0_linux_amd64.zip
unzip terraform_1.7.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform version
```

### Authenticating to Terraform Cloud

Before running any Terraform commands, you need to authenticate with Terraform Cloud:

```bash
# Set TFE token via environment variable
export TF_TOKEN_app_terraform_io="your-terraform-cloud-token"

# Or use terraform login (interactive)
terraform login
```

**Note:** Without proper authentication, `terraform init` will fail when attempting to connect to the remote backend.

## Common Workflows

### 1. Initialize Terraform

```bash
# Full initialization (connects to Terraform Cloud backend)
terraform init

# Initialize without backend (for validation only)
terraform init -backend=false
```

**Expected Behavior:** Downloads Cloudflare provider, connects to TFC workspace.

**Common Error:** If you see "Error: Failed to get existing workspaces", you need to authenticate to Terraform Cloud first.

### 2. Format Code

```bash
# Check formatting
terraform fmt -check -diff

# Auto-format all .tf files
terraform fmt -recursive
```

**Always run this before committing** to maintain consistent code style.

### 3. Validate Configuration

```bash
# Validate syntax and configuration
terraform validate
```

This checks for configuration errors without connecting to the backend.

## Pre-commit Auto-Fix

For same-repo PRs, the pre-commit workflow may commit and push auto-fixes.
When it does, it should leave a PR comment summarizing the commit and files
changed. Forked PRs are read-only and should fail with guidance instead of
pushing changes.

## Pull Request Policy

Always create a PR for changes in this repo. Never push directly to `main`.

### 4. Plan Changes

```bash
# Create an execution plan
terraform plan

# Save plan to file
terraform plan -out=tfplan
```

**Note:** This requires Terraform Cloud authentication and Cloudflare API token.

### 5. Apply Changes

```bash
# Apply changes (with confirmation)
terraform apply

# Apply saved plan
terraform apply tfplan

# Auto-approve (use with caution)
terraform apply -auto-approve
```

## Required Environment Variables

When working with this repository, you'll need:

1. **Terraform Cloud Token:**
   ```bash
   export TF_TOKEN_app_terraform_io="your-tfc-token"
   ```

2. **Cloudflare API Token:**
   ```bash
   export TF_VAR_cloudflare_api_token="your-cloudflare-token"
   # OR pass via -var flag
   terraform plan -var="cloudflare_api_token=your-token"
   # OR create a .tfvars file (not committed)
   ```

## Security Considerations

### ⚠️ Known Security Issues

1. **Hardcoded Email in Code:**
   - The file `main.tf` contains a hardcoded email address (`hyper123@gmail.com`)
   - This should be moved to a variable or environment variable
   - **Do not commit additional sensitive information**

2. **Legacy Cloudflare Authentication:**
   - Currently using email + API key authentication
   - Modern best practice: Use API token only (without email)
   - Consider migrating to: `api_token = var.cloudflare_api_token`

3. **Sensitive Files:**
   - `.tfvars` and `.tfvars.json` files are gitignored
   - Never commit files containing API tokens, keys, or sensitive data
   - State files are stored remotely in Terraform Cloud (not local)

### Best Practices

- **Always use variables** for sensitive data
- **Use environment variables** (TF_VAR_*) for local development
- **Use Terraform Cloud variables** for production workspaces
- **Enable version control** for .terraform.lock.hcl (currently gitignored incorrectly)

## File Organization

### provider.tf
Contains:
- Terraform backend configuration (remote)
- Provider version constraints
- Required Terraform version (should be added)

### main.tf
Contains:
- Provider instance configuration
- **Current Issue:** Contains provider block that duplicates provider.tf

### vars.tf
Contains:
- Input variable definitions
- Variable types and descriptions
- Sensitive variable flags

### .gitignore
Standard Terraform gitignore with patterns for:
- `.terraform/` directory
- State files (`*.tfstate`)
- Variable files (`*.tfvars`)
- Lock files (`.terraform.lock.hcl` - **should NOT be ignored**)
- Override files
- CLI configuration files

## Common Issues and Workarounds

### Issue 1: "Backend initialization required"
**Symptom:** Error about backend not being initialized

**Solution:**
```bash
terraform init
```

Make sure you're authenticated to Terraform Cloud first.

### Issue 2: "Error loading state"
**Symptom:** Cannot load state from Terraform Cloud

**Solution:**
- Check TFC authentication: `terraform login`
- Verify workspace exists in TFC
- Check internet connectivity

### Issue 3: "Missing Cloudflare API token"
**Symptom:** Provider cannot authenticate

**Solution:**
```bash
export TF_VAR_cloudflare_api_token="your-token"
# OR
terraform plan -var="cloudflare_api_token=your-token"
```

### Issue 4: Terraform not installed
**Symptom:** `terraform: command not found`

**Solution:**
Install Terraform using the commands in the Prerequisites section above.

### Issue 5: Provider version conflicts
**Symptom:** Provider version incompatibility errors

**Workaround:**
```bash
# Remove lock file and reinitialize
rm .terraform.lock.hcl
terraform init -upgrade
```

## Testing and Validation

### Pre-commit Checks
Before committing changes, always run:

```bash
# 1. Format code
terraform fmt -recursive

# 2. Validate configuration
terraform init -backend=false
terraform validate

# 3. Check for security issues (if available)
# terraform scan or tfsec (if installed)
```

### Testing Changes
```bash
# 1. Plan to see what will change
terraform plan

# 2. Review the plan carefully
# 3. Apply only if plan looks correct
terraform apply
```

**Note:** This repository does not have automated tests. All validation is manual through Terraform's plan/apply cycle.

## CI/CD Considerations

Currently, there are no GitHub Actions or CI/CD workflows configured. If adding CI/CD:

1. **Use Terraform Cloud runs** for execution
2. **Store secrets** in GitHub Secrets or TFC
3. **Require plan approval** before apply
4. **Use branch protection** for main branch

## Terraform Best Practices for This Repo

1. **Always run `terraform fmt`** before committing
2. **Always run `terraform validate`** before pushing
3. **Review plan output** carefully before applying
4. **Use workspaces** for different environments (if needed)
5. **Tag releases** when making significant infrastructure changes
6. **Document resources** with comments and descriptions
7. **Keep provider versions up to date** but test thoroughly
8. **Never commit** .tfvars files or secrets

## Quick Reference

| Command | Purpose |
|---------|---------|
| `terraform init` | Initialize backend and download providers |
| `terraform init -backend=false` | Initialize without backend (for validation) |
| `terraform fmt` | Format all .tf files |
| `terraform fmt -check` | Check if formatting is needed |
| `terraform validate` | Validate configuration syntax |
| `terraform plan` | Show what changes will be made |
| `terraform apply` | Apply changes to infrastructure |
| `terraform destroy` | Destroy all managed infrastructure |
| `terraform workspace list` | List available workspaces |
| `terraform state list` | List resources in state |
| `terraform providers` | Show provider requirements |

## Additional Notes

- **State Management:** All state is managed remotely in Terraform Cloud. You won't see .tfstate files locally.
- **Locking:** Terraform Cloud automatically handles state locking during operations.
- **Collaboration:** Multiple team members can work on this repo, but only one can apply changes at a time (via state locking).
- **Empty Configuration:** Currently, main.tf only contains provider configuration. Actual infrastructure resources need to be added.

## Getting Help

- Terraform Documentation: https://www.terraform.io/docs
- Cloudflare Provider Docs: https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
- Terraform Cloud Docs: https://www.terraform.io/cloud-docs

## Future Improvements

Consider adding:
- [ ] Terraform version constraint in provider.tf
- [ ] Proper module structure as infrastructure grows
- [ ] GitHub Actions for automated plan/apply
- [ ] Security scanning (tfsec, checkov)
- [ ] Pre-commit hooks for formatting and validation
- [ ] Move hardcoded email to variable
- [ ] Migrate to API token-only authentication
- [ ] Commit .terraform.lock.hcl (remove from .gitignore)
