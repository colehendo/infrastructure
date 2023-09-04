variable "project_name" {
  description = "The name of the project. Used to name infrastructure components"
  type        = string
  default     = "colehendo-app"
}

variable "ecr_image" {
  description = "The desired ECR image URL."
  type        = string
  default     = "colehendo-app"
}

variable "aws_region" {
  description = "The AWS region to deploy code in"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

# A boolean flag to enable or disable DNS support in the VPC
variable "vpc_dns_support" {
  description = "Should DNS support be enabled for the VPC?"
  type        = bool
  default     = true
}

# A boolean flag to enable or disable DNS hostnames in the VPC
variable "vpc_dns_hostnames" {
  description = "Should DNS hostnames support be enabled for the VPC?"
  type        = bool
  default     = true
}

# A boolean flag to map the public IP on launch for public subnets
variable "map_public_ip" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
  type        = bool
  default     = true
}

# The CIDR block for the public subnet. This block should be a range within the above VPC CIDR
variable "first_public_cidr" {
  description = "The CIDR block for the first public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

# The CIDR block for the public subnet. This block should be a range within the above VPC CIDR
variable "second_public_cidr" {
  description = "The CIDR block for the second public subnet."
  type        = string
  default     = "10.0.2.0/24"
}

# The CIDR block for the first private subnet. This block should be a range within the above VPC CIDR
variable "first_private_cidr" {
  description = "The CIDR block for the first private subnet."
  type        = string
  default     = "10.0.3.0/24"
}

# The CIDR block for the second private subnet. This block should be a range within the above VPC CIDR
variable "second_private_cidr" {
  description = "The CIDR block for the second private subnet."
  type        = string
  default     = "10.0.4.0/24"
}

variable "desired_capacity" {
  description = "Number of instances to launch in the ECS cluster."
  type        = number
  default     = 1
}

variable "maximum_capacity" {
  description = "Maximum number of instances that can be launched in the ECS cluster."
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "EC2 instance type for ECS launch configuration."
  type        = string
  default     = "t2.micro"
}
