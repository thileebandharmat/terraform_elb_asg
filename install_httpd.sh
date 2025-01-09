#!/bin/bash
sudo yum update
sudo yum install -y httpd
sudo systemctl enable httpd
echo "<h1>Thank you all for showing interest in this shell scripting session</h1>" | sudo tee /var/www/html/index.html
sudo systemctl restart httpd