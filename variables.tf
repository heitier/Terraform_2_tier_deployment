variable "aws_region" {
  type = string

  default = "us-east-1"

}


variable "user_data_sh" {
  default = <<-EOF
               #!/bin/bash
                export DEBIAN_FRONTEND=noninteractive

                apt-get update
                apt-get upgrade -y
                apt-get install -y apache2 php php-mysql libapache2-mod-php php-cli php-cgi php-gd
                systemctl restart apache2
                sudo apt install -y mysql-client
                cd /var/www/html
                sudo wget https://wordpress.org/latest.tar.gz
                sudo tar -xzf latest.tar.gz
                sudo rm -rf latest.tar.gz
                              
               EOF
}

