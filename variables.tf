variable "aws_region" {
  type = string

  default = "us-east-1"

}


variable "user_data_sh" {
  default = <<-EOF
               #!/bin/bash
               sudo yum update -y
  sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
  sudo yum install -y httpd mariadb-server
  sudo systemctl start httpd
  sudo systemctl enable httpd
  sudo systemctl start mariadb
  sudo systemctl enable mariadb
               
               
               EOF
}

