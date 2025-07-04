variable "aws_region" {
  description = "AWS region to deploy resources in."
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Project name prefix for resources."
  type        = string
  default     = "ruta"
}

variable "db_password" {
  description = "Password for the RDS MySQL instance."
  type        = string
  sensitive   = true
  default     = "p@ssword"
}

variable "ec2_key_name" {
  description = "SSH key pair name for EC2 instance."
  type        = string
}

