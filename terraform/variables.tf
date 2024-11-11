variable "vpc_id" {
  description = "The ID of the VPC where the instance will be deployed"
  type        = string
  default     = "vpc-0ec8ae419af17fdad"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu Server 20.04"
  type        = string
  default     = "ami-0862be96e41dcbf74"
}

variable "instance_name" {
  description = "Name for the EC2 instance"
  default     = "MyEC2Instance_1" # Cambia según tu preferencia
}