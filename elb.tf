#create new load balancer

resource "aws_elb" "terra-elb" {
  name = "terra-elb"
  subnets = aws_subnet.public.*.id
  security_groups = [aws_security_group.webservers.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 30
    target              = "HTTP:80/index.html"
    timeout             = 3
    unhealthy_threshold = 2
  }

  instances = [aws_instance.web_servers[0].id,aws_instance.web_servers[1].id]
  cross_zone_load_balancing = true
  idle_timeout = 100
  connection_draining = true
  connection_draining_timeout = 300

  tags = {
    Name = "terraform-elb"
  }
}