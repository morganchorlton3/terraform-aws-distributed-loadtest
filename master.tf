locals {
  setup_leader_executors = {
    locust = {
      leader_user_data_base64 = base64encode(
        templatefile(
          "${path.module}/scripts/locust/setup_master.sh.tpl",
          {}
        )
      )
    }
  }

  setup_leader_executor = lookup(local.setup_leader_executors, var.load_test_tool)

  setup_leader_base64 = local.setup_leader_executor.leader_user_data_base64
}

resource "aws_instance" "master" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  associate_public_ip_address = true

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.master.id]

  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  user_data_base64     = local.setup_leader_base64

  key_name = aws_key_pair.generated_key.key_name
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ssh_key.private_key_pem
  }

  tags = {
    Name = "${var.project_name}-master"
  }
}
resource "null_resource" "master_file_sync" {
  triggers = {
    file_changes = sha1(join("", [for f in fileset(var.test_files_directory, "**"): filesha1("${var.test_files_directory}/${f}")]))
  }

  connection {
    host        = aws_instance.master.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ssh_key.private_key_pem
    timeout     = "10m"
  }

  provisioner "file" {
    destination = "/home/ubuntu"
    source      = var.test_files_directory
  }

  depends_on = [aws_instance.master]
}
resource "null_resource" "master_setup" {
  triggers = {
    always_run = timestamp()
  }

  connection {
    host        = aws_instance.master.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ssh_key.private_key_pem
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "echo SETTING UP NODES....",
      "${var.loadtest_master_entrypoint}",
    ]
  }

  depends_on = [
    aws_instance.master,
    null_resource.master_file_sync
  ]
}