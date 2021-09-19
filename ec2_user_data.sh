
#!/bin/bash

USER_FOLDER=/home/ec2-user

# OS FIREWALL CHANGES
# Drop packets if they do not match any of the above exceptions.
sudo iptables -P INPUT DROP
# Uncomment the rule below if you need SSH access to the instance
# sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT 
sudo iptables -A INPUT -p udp --sport 53 -j ACCEPT # Needed for DNS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT # Needed for nginx
sudo iptables -A INPUT -p tcp --sport 80 -j ACCEPT # Needed for installing packages.
sudo iptables -A INPUT -p tcp --sport 443 -j ACCEPT # Needed for installing packages
sudo iptables -A INPUT -p tcp --dport 8000 -j ACCEPT # Needed for the REST API Search server

# DOCKER INSTALLATION
sudo yum update
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

# Run NGINX container with custom configuration
sudo -u ec2-user mkdir $USER_FOLDER/nginx-conf
sudo -u ec2-user mkdir $USER_FOLDER/nginx-container
sudo -u ec2-user aws s3 cp s3://nginx.alessandro.stagni/config/nginx.conf $USER_FOLDER/nginx-conf/nginx.conf
sudo -u ec2-user docker run -d -p 80:80 -v $USER_FOLDER/nginx-conf/nginx.conf:/etc/nginx/nginx.conf -v $USER_FOLDER/nginx-container:$USER_FOLDER/nginx-container --name nginx-server nginx

# Run logging script
sudo -u ec2-user mkdir logger
sudo -u ec2-user aws s3 cp s3://nginx.alessandro.stagni/script/logger.sh $USER_FOLDER/logger/logger.sh
sudo -u ec2-user bash $USER_FOLDER/logger/logger.sh &

# Search Script
sudo -u ec2-user mkdir $USER_FOLDER/script
sudo -u ec2-user aws s3 cp s3://nginx.alessandro.stagni/script/requirements.txt $USER_FOLDER/script/requirements.txt
sudo -u ec2-user aws s3 cp s3://nginx.alessandro.stagni/script/search.py $USER_FOLDER/script/search.py
sudo -u ec2-user pip3 install -r $USER_FOLDER/script/requirements.txt
sudo -u ec2-user python3 $USER_FOLDER/script/search.py &
