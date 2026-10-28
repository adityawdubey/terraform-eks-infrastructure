# GitHub Secrets and Variables (main Environment)

This guide explains how to set up the required secrets and variables for the Terraform CI/CD workflow in the main environment.

## Environment Variables Setup

1. Go to your GitHub repository
2. Navigate to Settings > Environments
3. Click on "main" environment (create it if it doesn't exist)
4. Click "Add variable" and add the following variables:

### Required Variables

- AWS_REGION = ap-south-1
- TF_VERSION
- VPC_NAME 
- CLUSTER_NAME 

## Secrets Setup

1. In the same "main" environment settings
2. Click "Add secret" and add the following secrets:

### Required Secrets

- AWS_ROLE_ARN = 


## Security Notes

- Variables are visible in workflow logs
- Secrets are encrypted and not visible in logs
- Use secrets for sensitive information like credentials
- Use variables for non-sensitive configuration values

## Verification

To verify your setup:
1. Push a change to the main branch
2. Check the Actions tab
3. Look for the "EKS Infra Main Deployment" workflow
4. Verify that the workflow runs successfully

## Troubleshooting

If the workflow fails:
1. Check if all required variables and secrets are set
2. Verify the values are correct
3. Check the workflow logs for specific error messages
4. Ensure the AWS role has the necessary permissions
