#!/bin/bash

# GitHub Secrets Setup Script
# This script helps you generate and set up the required GitHub secrets for the deployment workflow

set -e

echo " GitHub Secrets Setup Script"
echo "=============================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ  $1${NC}"
}

print_success() {
    echo -e "${GREEN} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}  $1${NC}"
}

print_error() {
    echo -e "${RED} $1${NC}"
}

# Check if gh CLI is installed
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) is not installed."
        echo "Please install it from: https://cli.github.com/"
        exit 1
    fi
    
    if ! gh auth status &> /dev/null; then
        print_error "You are not authenticated with GitHub CLI."
        echo "Please run: gh auth login"
        exit 1
    fi
}

# Generate SSH key pair
generate_ssh_key() {
    local key_name="ruta-deploy-key"
    local key_file="$HOME/.ssh/$key_name"
    
    if [ -f "$key_file" ]; then
        print_warning "SSH key already exists at $key_file"
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Using existing SSH key"
            return
        fi
    fi
    
    print_info "Generating SSH key pair..."
    ssh-keygen -t rsa -b 4096 -f "$key_file" -N "" -C "ruta-deployment"
    print_success "SSH key generated at $key_file"
}

# Generate database password
generate_db_password() {
    local password=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
    echo "$password"
}

# Display secrets setup instructions
display_secrets_instructions() {
    local ssh_key_file="$HOME/.ssh/ruta-deploy-key"
    local db_password=$(generate_db_password)
    
    echo ""
    echo " Required GitHub Secrets"
    echo "=========================="
    echo ""
    echo "Please add the following secrets to your GitHub repository:"
    echo ""
    echo "1. AWS Credentials:"
    echo "   - AWS_ACCESS_KEY_ID: Your AWS access key"
    echo "   - AWS_SECRET_ACCESS_KEY: Your AWS secret access key"
    echo ""
    echo "2. Database Credentials:"
    echo "   - DB_PASSWORD: $db_password"
    echo "   - DB_NAME: ruta_db"
    echo "   - DB_USER: admin"
    echo ""
    echo "3. SSH Access:"
    echo "   - SSH_PRIVATE_KEY: $(cat $ssh_key_file)"
    echo "   - EC2_KEY_NAME: ruta-deploy-key"
    echo ""
    echo "🔧 How to add secrets:"
    echo "1. Go to your GitHub repository"
    echo "2. Click Settings > Secrets and variables > Actions"
    echo "3. Click 'New repository secret'"
    echo "4. Add each secret with the exact name and value shown above"
    echo ""
    echo " AWS Setup Instructions:"
    echo "1. Create an IAM user with the following permissions:"
    echo "   - AmazonEC2FullAccess"
    echo "   - AmazonRDSFullAccess"
    echo "   - AmazonS3FullAccess"
    echo "   - AmazonCloudFrontFullAccess"
    echo "   - AmazonVPCFullAccess"
    echo "   - AmazonIAMFullAccess"
    echo ""
    echo "2. Generate access keys for the IAM user"
    echo "3. Add the access keys as GitHub secrets"
    echo ""
    echo " SSH Key Setup:"
    echo "1. The SSH key has been generated at: $ssh_key_file"
    echo "2. Add the public key to your AWS account:"
    echo "   - Go to AWS Console > EC2 > Key Pairs"
    echo "   - Create a new key pair named 'ruta-deploy-key'"
    echo "   - Or import the public key: $(cat ${ssh_key_file}.pub)"
    echo ""
}

# Main execution
main() {
    print_info "Checking prerequisites..."
    check_gh_cli
    print_success "GitHub CLI is ready"
    
    print_info "Generating SSH key pair..."
    generate_ssh_key
    
    print_info "Generating database password..."
    display_secrets_instructions
    
    print_success "Setup complete!"
    echo ""
    print_info "Next steps:"
    echo "1. Add all the secrets to your GitHub repository"
    echo "2. Create the AWS key pair"
    echo "3. Push your code to trigger the workflow"
    echo ""
    print_warning "Remember to keep your secrets secure and never commit them to version control!"
}

# Run main function
main "$@" 