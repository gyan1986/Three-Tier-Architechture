#! /bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo chown ec2-user /var/www/html
sudo echo "Hello world from $(hostname -f)" > /var/www/html/index.html