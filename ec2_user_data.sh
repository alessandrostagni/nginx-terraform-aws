
#! /bin/bash

# OS FIREWALLING CHANGES!
sudo apt update
sudo apt install -y docker-ce
# sudo usermod -aG docker admin

mkdir nginx-conf
aws s3 cp alessandro_bucket/config/nginx.conf ./nginx-conf/nginx.conf

docker run -d -p 80:80 -v nginx-conf /etc/nginx/ --name nginx-server nginx
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Terraform Instance Launched Successfully</h1>" | sudo tee /var/www/html/index.html