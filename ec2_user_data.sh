
#!/bin/bash

# OS FIREWALLING CHANGES
# Allow only HTTP connections
# echo "127.0.0.1 $(hostname)" | sudo tee -a /etc/hosts # Used to avoid this error: 
sudo iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 8000 -j ACCEPT
# Keep DNS port open
sudo iptables -A OUTPUT -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp --sport 53 -m state --state ESTABLISHED -j ACCEPT 
#sudo iptables -t filter -P INPUT DROP 


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
bash logger/logger.sh

# Search Script
pip3 install -r script/requirements.txt
python3 search.py
