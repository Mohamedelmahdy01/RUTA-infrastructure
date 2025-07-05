# DevOps Project Structure on AWS 

This repository contains the infrastructure and automation code for deploying and managing a Laravel-based application on AWS.

## Structure

- **terraform/**  
  Infrastructure as Code (IaC) using Terraform.  
  Includes modules for VPC, EC2, RDS, S3, CloudFront, and other AWS resources.

- **ansible/**  
  Server configuration and provisioning using Ansible.  
  Handles installation and setup of Nginx, PHP, Laravel, SSL certificates, and more.

- **scripts/**  
  Utility and helper scripts, such as database backup and restore, log rotation, and maintenance tasks.

```plaintext
RUTA-infrastructure
├── terraform/           # Infrastructure configurations
│   ├── main.tf          
│   ├── variables.tf     
│   ├── outputs.tf       
│   └── provider.tf/         
├── ansible/             # Ansible files for server setup
│   ├── ansible.cfg      # Ansible configuration file
│   ├── inventory.ini        # Target hosts
│   ├── nginx_laravel.j2
│   ├── playbooks.yml      
├── scripts/             
│   ├── mysql_backup.sh 
│   ├── README.md       
│   ├── setup-github-secrets.ps1       
│   ├── setup-github-secrets.sh
|──.gitignore
├── README.md            # Project documentation
```

## Workflow Steps

### Manual Deployment
1. **Set up infrastructure with Terraform**  
   Initialize and apply Terraform configurations to provision AWS resources.

2. **Configure server with Ansible**  
   Use Ansible playbooks to install and configure all necessary software on the EC2 instances.

3. **Schedule backup scripts**  
   Automate regular backups and other maintenance tasks using scripts and cron jobs.

### Automated Deployment (GitHub Actions)
We've implemented a comprehensive GitHub Actions workflow that automates the entire deployment process:

- **Automatic triggers**: Push to main/develop branches or pull requests
- **Manual triggers**: Manual workflow dispatch with environment and action options
- **Security**: Environment protection and secret management
- **Monitoring**: Health checks and deployment verification

See [`.github/workflows/README.md`](.github/workflows/README.md) for detailed setup instructions.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) >= 2.9
- AWS CLI configured with appropriate credentials
- SSH access to your EC2 instances

## Getting Started

### Option 1: Automated Deployment (Recommended)

1. **Clone the repository**
   ```sh
   git clone https://github.com/your-org/ruta-infrastructure.git
   cd ruta-infrastructure
   ```

2. **Set up GitHub Secrets**
   ```sh
   # On Linux/macOS
   ./scripts/setup-github-secrets.sh
   
   # On Windows
   .\scripts\setup-github-secrets.ps1
   ```

3. **Configure AWS and GitHub**
   - Add the generated secrets to your GitHub repository
   - Create the AWS key pair as instructed
   - Push your code to trigger the automated deployment

### Option 2: Manual Deployment

1. **Clone the repository**
   ```sh
   git clone https://github.com/your-org/ruta-infrastructure.git
   cd ruta-infrastructure
   ```

2. **Provision AWS Infrastructure**
   ```sh
   cd terraform
   terraform init
   terraform apply
   ```

3. **Configure Servers**
   ```sh
   cd ../ansible
   ansible-playbook -i inventory setup.yml
   ```

4. **Set Up Backups**
   - Review and schedule scripts in the `scripts/` directory as needed.

## Notes

- All resources are configured to work within the AWS Free Tier where possible.
- Remember to destroy resources when not in use to avoid unexpected charges:
  ```sh
  cd terraform
  terraform destroy
  ```

## License

This project is licensed under the MIT License.

