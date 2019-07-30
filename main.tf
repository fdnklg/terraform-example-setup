# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region = "eu-central-1"
  profile = "${var.profile}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    # set the preferenced linux server version here
    # values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# define the inbound and outbound rules for the security group
resource "aws_security_group" "public-group" {
   name        = "simple-task"
  description = "controls access to the simple task test"
    vpc_id      = "${var.vpc_id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  tags = {
    Name = "Public Security Group"
  }
  egress{
    from_port = 0
    to_port =0
    protocol = -1
    cidr_blocks =  ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${var.security_group}", "${aws_security_group.public-group.id}"]
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  tags = {
    # define the name of the ec2 instance
    Name = "ec2-trees"
  }
  
  provisioner "remote-exec" {
    connection {
        type = "ssh"
        host = "${aws_instance.web.public_dns}"
        # locate to your private ey.pem file
        private_key = "${file("/Users/enjoi/.aws/ec2.pem")}"
        port = 22
        user = "ubuntu"
    }

    inline = [
      "sudo apt-get update -y",
      "curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -",
      "sudo apt install git nodejs tmux zsh -y"
    ]
  }
}