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
                              
               EOF
}

