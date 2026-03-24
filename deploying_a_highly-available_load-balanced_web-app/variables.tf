variable "instance_type" {
  type = string
  description = "This is the type of ec2 instance we will use"
  default = "t3.micro"
}

variable "server_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "terraform-nginx-server"
}