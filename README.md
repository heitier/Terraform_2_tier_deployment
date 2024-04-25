# Deploying A Highly Available 2-Tier Architecture With Terraform
=======
WordPress on AWS with Terraform
This repository contains Terraform configurations to deploy a WordPress website on an AWS EC2 instance that connects to a MySQL database hosted on AWS RDS. This setup is designed to provide a scalable, secure, and efficient environment for running a WordPress site on AWS infrastructure.

Architecture Overview
EC2 Instance: Hosts the WordPress application, running on Amazon Linux 2 AMI. The instance is configured in a public subnet to be accessible via the Internet.
RDS MySQL Instance: Hosts the MySQL database for WordPress in a private subnet, ensuring that the database is not directly accessible from the Internet.
Security Groups: Properly configured to allow only necessary traffic to and from the EC2 and RDS instances.
Features
Automated setup of the WordPress environment on an EC2 instance.
Secure connection to a MySQL database hosted on RDS.
Easy scalability and management through the use of AWS services and Terraform.
Prerequisites
AWS Account
Terraform installed
An existing VPC with at least one public and one private subnet (modify configurations accordingly if using default VPC)
Key Pair for EC2 instance access
