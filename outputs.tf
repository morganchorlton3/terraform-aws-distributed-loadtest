output "locust_web_interface" {
  description = "URL for the Locust web interface"
  value       = "http://${aws_instance.master.public_ip}:8089"
}
output "ssh_connect_command" {
  description = "Command to connect to the master node via SSH"
  value       = "ssh -i ${local_file.private_key.filename} ubuntu@${aws_instance.master.public_ip}"
}