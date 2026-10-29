# CI/CD Setup (main Environment)

This guide explains how to set up the Terraform CI/CD workflow for the main environment.

## Configuration

Non-secret settings are committed to the repository, not stored in GitHub:

- `environments/main/terraform.tfvars`: region, VPC name, cluster name, availability zones and cluster admins (`cluster_admin_principal_arns`)
- `environments/main/backend.s3.tfbackend`: the existing Terraform state bucket (see [Create the Terraform state bucket](../../README.md#create-the-terraform-state-bucket-one-time))
- `main.yml` (`env`): Terraform version and AWS region

Change these through a commit to `main`. Changing `cluster_name` replaces the cluster.

## Secrets Setup

1. Go to your GitHub repository
2. Navigate to Settings > Environments
3. Click on "main" environment (create it if it doesn't exist)
4. Click "Add secret" and add the following secret:

### Required Secrets

- AWS_ROLE_ARN = ARN of the IAM role the workflow assumes through GitHub OIDC

The role's trust policy must allow the `main` environment of this repository:

- `token.actions.githubusercontent.com:aud` = `sts.amazonaws.com`
- `token.actions.githubusercontent.com:sub` = `repo:adityawdubey/terraform-eks-infrastructure:environment:main`

The role needs permission to create the stack's VPC, EKS and IAM resources and to read and write the state bucket.

## Environment Protection

Every push to `main` runs `terraform apply`. In the "main" environment settings:

1. Add yourself under "Required reviewers" so each apply waits for approval
2. Under "Deployment branches and tags", allow only the `main` branch

## Verification

To verify your setup:
1. Push a change to the main branch
2. Check the Actions tab
3. Look for the "EKS Infra Main Deployment" workflow
4. Verify that the workflow runs successfully

A commit message containing `[skip ci]` doesn't trigger a deployment. To pause deployments:

```bash
gh workflow disable "EKS Infra Main Deployment" -R adityawdubey/terraform-eks-infrastructure
```
