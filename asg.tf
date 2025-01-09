resource "aws_launch_template" "terra-lt" {
  name          = "terra-lt"
  image_id      = var.webservers_ami # Replace with your custom AMI ID
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.webservers.id
  ]
  user_data = base64encode(file("install_httpd.sh"))
}

resource "aws_autoscaling_group" "terra-asg" {
  launch_template {
    id      = aws_launch_template.terra-lt.id
    version = "$Latest"
  }
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2
  vpc_zone_identifier  = aws_subnet.public.*.id
  load_balancers = [aws_elb.terra-elb.name]
  health_check_type         = "ELB"
  health_check_grace_period = 300
  tag {
    key                 = "Name"
    value               = "terraform-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Attach the ELB to the ASG
resource "aws_autoscaling_attachment" "asg-elb-attach" {
  autoscaling_group_name = aws_autoscaling_group.terra-asg.id
  elb                    = aws_elb.terra-elb.name
}