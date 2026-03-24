# This block shows terraform which provider we are using and the region where we want to deploy 
provider "aws" {
  region = "eu-north-1"
}

# This block configured the security group and labels it 
resource "aws_security_group" "web_sg" {
  name = "web-sg-two"

  # Allowing http traffic by opening port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allowing SSH traffic by opening port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allowing all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Defining our Ubuntu Ec2 instance and installing nginx to server our web page.
resource "aws_instance" "web" {
  ami           = "ami-025d7bea93113b6cc"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Day 3: First Server Deployed by Mwangi</h1><p>Built with Terraform</p>" > /var/www/html/index.html              
              EOF
  tags = {
    Name = "terraform-nginx-server"
  }
}

# The output to print the public Ip of the instance if it successfully deployed
output "public_ip" {
  value = aws_instance.web.public_ip
}