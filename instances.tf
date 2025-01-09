resource "aws_instance" "web_servers" {
  count = length(var.subnets_cidr)
  ami   = var.webservers_ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.webservers.id]
  subnet_id = element(aws_subnet.public.*.id, count.index )
  user_data = file(("install_httpd.sh"))
  tags = {
    Name = "Server-2025-${count.index}"
  }
}