locals {
  setup_executors = {
    locust = {
      user_data_base64 = base64encode(
        templatefile(
          "${path.module}/scripts/locust/setup_worker.sh.tpl",
          {
            LEADER_IP = var.leader_ip
          }
        )
      )
    }
  }

  setup_executor = lookup(local.setup_executors, var.load_test_tool)

  setup_base64 = local.setup_executor.user_data_base64
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
resource "aws_instance" "master" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  associate_public_ip_address = true

  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile   = var.aws_ec2_instance_profile
  user_data_base64     = local.setup_base64

  key_name = var.aws_key_name
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.ssh_key
  }

  tags = {
    Name = var.instance_name
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
    private_key = var.ssh_key
    timeout     = "10m"
  }

  provisioner "file" {
    destination = "/home/ubuntu"
    source      = var.test_files_directory
  }

  depends_on = [aws_instance.master]
}
resource "null_resource" "master_run_locust" {
  triggers = {
    always_run = "${timestamp()}"
  }

  connection {
    host        = aws_instance.master.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.ssh_key
    timeout     = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "pkill locust || true",
      "${var.entrypoint}",
      "ps aux | grep locust"
    ]
  }

  depends_on = [
    aws_instance.master,
    null_resource.master_file_sync
  ]
}