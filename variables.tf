variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "master_instance_type" {
  description = "EC2 instance type for master nodes"
  type        = string
  default     = "t3.micro"
}
variable "worker_instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "worker_count" {
  description = "Number of worker nodes to deploy"
  type        = number
  default     = 1
}

variable "load_test_tool" {
  description = "Load testing tool to use (either 'locust' or 'k6')"
  type        = string
}

variable "test_files_directory" {
  description = "Path to directory containing test files"
  type        = string
  default     = ""
}

variable "master_entrypoint" {
  description = "Path to the entrypoint command"
  type        = string
}
variable "worker_entrypoint" {
  description = "Path to the entrypoint command"
  type        = string
}