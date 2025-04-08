
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "loadtest" {
  source = "../../"

  project_name         = "load-test"
  test_files_directory = "${path.root}/../../performance"

  master_instance_type = "t3.micro"
  worker_count         = 1
  load_test_tool       = "locust"
  master_entrypoint    = <<-EOT
    pip3 install dotenv
    nohup locust -f performance/locustfile.py --master --expect-workers=1 > locust-leader.out 2>&1 &
  EOT
  worker_entrypoint    = <<-EOT
    pip3 install dotenv
    nohup locust -f performance/locustfile.py --worker --master-host={LEADER_IP} > locust-leader.out 2>&1 &
  EOT
}

output "locust_web_interface" {
  value = module.loadtest.locust_web_interface
}
output "ssh_connect_command" {
  value = module.loadtest.ssh_connect_command
}
