
#!/bin/bash

# OS FIREWALL CHANGES
# Allow only HTTP connections
sudo iptables -P INPUT DROP
# Uncomment the rule below if you need ssh access to the instance
# sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT 
sudo iptables -A INPUT -p udp --sport 53 -j ACCEPT # Needed for DNS
sudo iptables -A INPUT -p tcp --sport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --sport 443 -j ACCEPT # Needed for installing packages
sudo iptables -A INPUT -p tcp --dport 8000 -j ACCEPT

# DOCKER INSTALLATION
sudo yum update
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

# Run NGINX container with custom configuration
mkdir nginx-conf
mkdir nginx-container
aws s3 cp s3://nginx.alessandro.stagni/config/nginx.conf ./nginx-conf/nginx.conf
docker run -d -p 80:80 -v /nginx-conf/nginx.conf:/etc/nginx/nginx.conf -v /var/log/nginx-container:/var/log/nginx-container --name nginx-server nginx

# Run logging script
mkdir logger
aws s3 cp s3://nginx.alessandro.stagni/script/logger.sh ./logger/logger.sh
bash logger/logger.sh &

# Search Script
mkdir script
aws s3 cp s3://nginx.alessandro.stagni/script/requirements.txt ./script/requirements.txt
aws s3 cp s3://nginx.alessandro.stagni/script/search.py ./script/search.py
pip3 install -r ./script/requirements.txt
python3 script/search.py &
