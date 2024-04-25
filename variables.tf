variable "aws_region" {
  type    = string
  default = "us-east-1"

}


variable "user_data_sh" {
  default = <<-EOF
               #!/bin/bash
               sudo apt update
               sudo apt install -y nginx
               systemctl status nginx
               
               EOF
}