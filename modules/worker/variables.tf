variable "instance_name" {
  description = "Name of the worker instance to create"
  type        = string
}

variable "load_test_tool" {
  description = "Load testing tool to use (either 'locust' or 'k6')"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for master and worker nodes"
  type        = string
  default     = "t3.micro"
}

variable "test_files_directory" {
  description = "Path to directory containing test files"
  type        = string
  default     = ""
}
variable "leader_ip" {
  description = "IP address of the leader instance"
  type        = string
}

variable "ssh_key" {
  description = "SSH key for the worker instance"
  type        = string
}

variable "aws_key_name" {
  description = "AWS key name for the worker instance"
  type        = string
}

variable "aws_ec2_instance_profile" {
  description = "AWS EC2 instance profile for the worker instance"
  type        = string
}

variable "security_group_ids" {
  description = "Security group ID for the worker instance"
  type        = list(string)
}

variable "subnet_id" {
  description = "Subnet ID for the worker instance"
  type        = string
}
variable "entrypoint" {
  description = "Path to the entrypoint command"
  type        = string
}