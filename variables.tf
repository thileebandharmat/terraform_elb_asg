variable "vpc_cidr" {
  default = "10.20.0.0/20"
}

variable "subnets_cidr" {
  type = list(any)
  default = ["10.20.1.0/24","10.20.2.0/24"]
}

variable "azs" {
  type = list(any)
  default = ["ap-south-1a","ap-south-1b"]
}

variable "webservers_ami" {
  default = "ami-00d44f75bdf85175d"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "sgname" {
  default = "terra_elb_asg"
}

variable "cidr" {
  default = ["0.0.0.0/0"]
}