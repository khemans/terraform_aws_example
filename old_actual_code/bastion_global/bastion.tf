##Create EC2 Instance for Bastion, Set a security group and use the latest Amazon Linux AMI

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  user_data     = file("${path.module}/resources/bastion.sh")
  subnet_id     = var.subnet_id
  key_name = var.key_name
  security_groups = [
    aws_security_group.bastion_sg.id
  ]
  #provisioner "file" {
  #  source = file("${path.module}/resources/gitlab_members.sh")
  #  destination = "/gitlab_members.sh"
  #}
  tags = var.tags
}

resource "aws_security_group" "bastion_sg" {
  name = "bastion-sg-${var.environment}"
  description = "Security group for Bastion Host"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_eip" "bastion_eip" {
  instance  = aws_instance.bastion.id
  tags = var.tags
}
