data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "tuan-ssh"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDaLfTbAgC164/bGqM1cd3nm6zkeO9R3lFvvkmgYpQD tuanssh"
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic_from_alb" {
  security_group_id            = aws_security_group.instance_sg.id
  referenced_security_group_id = var.alb_sg_id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.instance_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.instance_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
###############################################################################################################

resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    Name = "instance_sg"
  }
}

# Resource block to create the EC2 instance
resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type # Choose an instance type as needed
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = aws_key_pair.ssh_key.key_name

  tags = {
    Name    = var.instance_name
    Project = "devops"
    Creator = "Tuan"
  }

  user_data = file("./userdata.sh")
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.ubuntu.id
  port             = 80
}
