module "worker" {
  count  = var.worker_count
  source = "./modules/worker"

  instance_name        = "${var.project_name}-worker-${count.index + 1}"
  load_test_tool       = var.load_test_tool
  test_files_directory = var.test_files_directory

  subnet_id = aws_subnet.public.id
  security_group_ids = [aws_security_group.master.id]

  instance_type            = var.worker_instance_type
  ssh_key                  = tls_private_key.ssh_key.private_key_pem
  aws_key_name             = aws_key_pair.generated_key.key_name
  aws_ec2_instance_profile = aws_iam_instance_profile.ec2_profile.name

  entrypoint = local.worker_entry_point

  leader_ip = aws_instance.master.public_ip
}