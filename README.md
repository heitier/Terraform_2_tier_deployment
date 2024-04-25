# WordPress on AWS with Terraform
This repository contains Terraform configurations to deploy a WordPress website on an AWS EC2 instance that connects to a MySQL database hosted on AWS RDS. This setup is designed to provide a scalable, secure, and efficient environment for running a WordPress site on AWS infrastructure.

## Architecture Overview
* **EC2 Instance**: Hosts the WordPress application, running on Amazon Linux 2 AMI. The instance is configured in a public subnet to be accessible via the Internet.
* **RDS MySQL Instance**: Hosts the MySQL database for WordPress in a private subnet, ensuring that the database is not directly accessible from the Internet.
* **Security Groups**: Properly configured to allow only necessary traffic to and from the EC2 and RDS instances.

## Features

* Automated setup of the WordPress environment on an EC2 instance.
* Secure connection to a MySQL database hosted on RDS.
* Easy scalability and management through the use of AWS services and Terraform.

## Prerequisites

* AWS Account
* Terraform installed
* An existing VPC with at least one public and one private subnet (modify configurations accordingly if using default VPC)
* Key Pair for EC2 instance access

## Usage
### Clone the Repository
Start by cloning this repository to your local machine:

### Configure AWS Credentials
Ensure that your AWS credentials are configured. This can typically be done via the AWS CLI:
```
aws configure
```
### Initialize Terraform
Run Terraform init to initialize the project, which will download required providers and modules:
```
terraform init
```
### Apply Terraform Configuration
Preview and apply the configuration:
```
terraform plan
terraform apply
```
### Access WordPress
After the infrastructure is provisioned, access your WordPress site by navigating to the public IP address of the EC2 instance.

### Customization
You can customize the configurations by modifying the Terraform variables in the variables.tf file to suit your specific requirements, such as changing the instance types, adjusting the database size, or configuring additional AWS services.

## Security Considerations
Ensure that the database password and other sensitive information are managed securely, preferably using AWS Secrets Manager or a similar service.
Regularly update and patch the operating system and WordPress software on the EC2 instance.
Restrict SSH access to the EC2 instance to known IP addresses.

## Contributions
Contributions are welcome! For major changes, please open an issue first to discuss what you would like to change.

Please ensure to update tests as appropriate.

