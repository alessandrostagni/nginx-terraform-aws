
#! /bin/bash

# OS FIREWALLING CHANGES
# Allow only HTTP connections
iptables -t filter -F 
iptables -t filter -X

iptables -t filter -P INPUT DROP 
iptables -t filter -P FORWARD DROP 
iptables -t filter -P OUTPUT DROP

iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT

# DOCKER INSTALLATION
sudo apt update
sudo apt install -y docker-ce
sudo usermod -aG docker admin

mkdir nginx-conf
aws s3 cp alessandro_bucket/config/nginx.conf ./nginx-conf/nginx.conf

docker run -d -p 80:80 -v nginx-conf /etc/nginx/ --name nginx-server nginx
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Terraform Instance Launched Successfully</h1>" | sudo tee /var/www/html/index.html