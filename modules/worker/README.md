<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.90 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.90 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [null_resource.master_file_sync](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.master_run_locust](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_ec2_instance_profile"></a> [aws\_ec2\_instance\_profile](#input\_aws\_ec2\_instance\_profile) | AWS EC2 instance profile for the worker instance | `string` | n/a | yes |
| <a name="input_aws_key_name"></a> [aws\_key\_name](#input\_aws\_key\_name) | AWS key name for the worker instance | `string` | n/a | yes |
| <a name="input_entrypoint"></a> [entrypoint](#input\_entrypoint) | Path to the entrypoint command | `string` | n/a | yes |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name of the worker instance to create | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type for master and worker nodes | `string` | `"t3.micro"` | no |
| <a name="input_leader_ip"></a> [leader\_ip](#input\_leader\_ip) | IP address of the leader instance | `string` | n/a | yes |
| <a name="input_load_test_tool"></a> [load\_test\_tool](#input\_load\_test\_tool) | Load testing tool to use (either 'locust' or 'k6') | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group ID for the worker instance | `list(string)` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | SSH key for the worker instance | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID for the worker instance | `string` | n/a | yes |
| <a name="input_test_files_directory"></a> [test\_files\_directory](#input\_test\_files\_directory) | Path to directory containing test files | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->