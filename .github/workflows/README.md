# GitHub Workflow for Infrastructure and Application Deployment

This workflow automates the deployment of your infrastructure using Terraform and application deployment using Ansible.

## Overview

The workflow consists of three main jobs:

1. **Terraform Plan** - Validates and plans infrastructure changes
2. **Terraform Apply** - Applies infrastructure changes and captures outputs
3. **Ansible Deployment** - Deploys the application to the provisioned infrastructure

## Prerequisites

### Required GitHub Secrets

You need to configure the following secrets in your GitHub repository:

1. **AWS Credentials:**
   - `AWS_ACCESS_KEY_ID` - Your AWS access key
   - `AWS_SECRET_ACCESS_KEY` - Your AWS secret access key

2. **Database Credentials:**
   - `DB_PASSWORD` - Password for the RDS MySQL instance
   - `DB_NAME` - Database name (e.g., "ruta_db")
   - `DB_USER` - Database username (e.g., "admin")

3. **SSH Access:**
   - `SSH_PRIVATE_KEY` - Private SSH key for EC2 instance access
   - `EC2_KEY_NAME` - Name of the SSH key pair in AWS

### Repository Structure

```
├── .github/
│   └── workflows/
│       └── deploy.yml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── provider.tf
├── ansible/
│   ├── playbook.yml
│   ├── inventory.ini
│   ├── env.j2
│   └── nginx_laravel.j2
└── README.md
```

## Workflow Triggers

### Automatic Triggers

1. **Push to main/develop branches** - Triggers full deployment
2. **Pull Request to main** - Triggers Terraform plan only
3. **Changes to terraform/ or ansible/ directories** - Triggers appropriate jobs

### Manual Triggers

You can manually trigger the workflow with the following options:

- **Environment**: staging or production
- **Terraform Action**: plan, apply, or destroy

## Workflow Jobs

### 1. Terraform Plan

**Triggers:** Pull requests, manual plan action
**Purpose:** Validates and plans infrastructure changes

**Steps:**
- Checkout code
- Setup Terraform
- Configure AWS credentials
- Initialize Terraform
- Format check
- Validate configuration
- Create plan
- Upload plan artifact

### 2. Terraform Apply

**Triggers:** Push to main branch, manual apply action
**Purpose:** Applies infrastructure changes and captures outputs

**Steps:**
- Checkout code
- Setup Terraform
- Configure AWS credentials
- Download plan artifact
- Initialize Terraform
- Apply changes
- Capture outputs
- Upload outputs artifact

### 3. Ansible Deployment

**Triggers:** Push to main branch, manual apply action
**Purpose:** Deploys application to provisioned infrastructure

**Steps:**
- Checkout code
- Download Terraform outputs
- Setup Python and Ansible
- Configure AWS credentials
- Extract EC2 IP and RDS endpoint
- Generate Ansible inventory
- Setup SSH access
- Wait for EC2 readiness
- Run Ansible playbook
- Perform health check

### 4. Terraform Destroy

**Triggers:** Manual destroy action
**Purpose:** Destroys all infrastructure resources

**Steps:**
- Checkout code
- Setup Terraform
- Configure AWS credentials
- Initialize Terraform
- Destroy infrastructure

## Environment Protection

The workflow uses GitHub Environments for additional protection:

- **Production Environment**: Requires approval for destructive actions
- **Staging Environment**: Allows automatic deployment

## Security Considerations

1. **Secrets Management**: All sensitive data is stored as GitHub secrets
2. **SSH Key Security**: SSH private key is securely handled
3. **AWS Credentials**: IAM roles with minimal required permissions
4. **Environment Protection**: Manual approval for production deployments

## Troubleshooting

### Common Issues

1. **Terraform Plan Fails**
   - Check AWS credentials
   - Verify Terraform configuration syntax
   - Ensure all required variables are set

2. **Ansible Deployment Fails**
   - Verify SSH private key is correct
   - Check EC2 instance is running
   - Ensure security groups allow SSH access

3. **Health Check Fails**
   - Check Nginx configuration
   - Verify Laravel application is running
   - Check firewall settings

### Debugging

1. **Enable Debug Output**: The Ansible playbook runs with `-vv` for verbose output
2. **Check Artifacts**: Terraform outputs are saved as artifacts for inspection
3. **Review Logs**: All job logs are available in the GitHub Actions interface

## Best Practices

1. **Branch Protection**: Protect main branch with required reviews
2. **Environment Protection**: Use GitHub Environments for production
3. **Secret Rotation**: Regularly rotate AWS credentials and SSH keys
4. **Testing**: Test changes in staging before production
5. **Monitoring**: Set up monitoring for deployed applications

## Customization

### Adding New Environments

1. Add new environment to workflow inputs
2. Create corresponding GitHub Environment
3. Update Terraform variables for environment-specific values

### Modifying Deployment Steps

1. Update Ansible playbook for application-specific requirements
2. Modify health check for your application
3. Add additional post-deployment steps as needed

### Adding Notifications

1. Configure Slack/Discord webhooks
2. Add notification steps to workflow
3. Include deployment status and URLs

## Support

For issues or questions:
1. Check the workflow logs for detailed error messages
2. Verify all secrets are correctly configured
3. Test locally with Terraform and Ansible before pushing 
