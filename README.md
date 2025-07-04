# DevOps Project Structure on AWS (Free Tier)

This repository contains the infrastructure and automation code for deploying and managing a Laravel-based application on AWS, optimized for the Free Tier.

## Structure

- **terraform/**  
  Infrastructure as Code (IaC) using Terraform.  
  Includes modules for VPC, EC2, RDS, S3, CloudFront, and other AWS resources.

- **ansible/**  
  Server configuration and provisioning using Ansible.  
  Handles installation and setup of Nginx, PHP, Laravel, SSL certificates, and more.

- **scripts/**  
  Utility and helper scripts, such as database backup and restore, log rotation, and maintenance tasks.

## Workflow Steps

1. **Set up infrastructure with Terraform**  
   Initialize and apply Terraform configurations to provision AWS resources.

2. **Configure server with Ansible**  
   Use Ansible playbooks to install and configure all necessary software on the EC2 instances.

3. **Schedule backup scripts**  
   Automate regular backups and other maintenance tasks using scripts and cron jobs.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) >= 2.9
- AWS CLI configured with appropriate credentials
- SSH access to your EC2 instances

## Getting Started

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

