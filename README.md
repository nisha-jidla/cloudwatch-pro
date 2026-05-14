## Stage 6: CI/CD with GitHub Actions

Automated Terraform validation using GitHub Actions to ensure 
infrastructure changes are planned and reviewed on every push.

### What was built
- GitHub Actions workflow triggered on push to `master` and `main`
- Terraform Init and Plan run automatically on every commit
- Workflow handles output-only changes gracefully using 
  `continue-on-error: true`
- AWS and Azure credentials managed securely via GitHub Secrets

### Tools used
- GitHub Actions
- Terraform
- AWS (credentials via secrets)
- Azure (credentials via secrets)

### Key files
- `.github/workflows/terraform-plan.yml`

### Result
Every push to the repo automatically validates the Terraform 
configuration across both AWS and Azure — giving confidence 
that infrastructure changes are safe before any manual apply.