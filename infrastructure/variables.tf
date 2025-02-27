variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "env" {
  description = "Name of the Environemnt"
  type        = string
}

variable "name" {
  description = "Name of the VPC"
  type        = string
  default     = "nginx"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "domain_name" {
  description = "The base domain name for the application"
  type        = string
  default     = "reactapp.com"
}

variable "hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID"
  type        = string
}

variable "min_task_count" {
  description = "Minimum number of ECS tasks"
  type        = number
}

variable "max_task_count" {
  description = "Maximum number of ECS tasks"
  type        = number
}

