#!/bin/bash
set -x

# Install necessary dependencies

sudo yum -y -qq install wget git curl
sudo yum -y -qq install docker

# Setup sudo to allow no-password sudo for "engineering" group and adding "vadeleke" user
sudo groupadd -r engineering
sudo useradd -m -s /bin/bash vadeleke
sudo usermod -a -G engineering vadeleke
sudo cp /etc/sudoers /etc/sudoers.orig
echo "vadeleke  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/vadeleke

# Installing SSH key
sudo mkdir -p /home/vadeleke/.ssh
sudo chmod 700 /home/vadeleke/.ssh
sudo cp /tmp/vadeleke.pub /home/vadeleke/.ssh/authorized_keys
sudo cp /tmp/vadeleke /home/vadeleke/.ssh
sudo chmod 400 /home/vadeleke/.ssh/vadeleke
sudo chmod 600 /home/vadeleke/.ssh/authorized_keys
sudo chown -R vadeleke /home/vadeleke/.ssh
sudo usermod --shell /bin/bash vadeleke

# Install Docker, Configure docker to start at boot time and run Prometheus

sudo -H -i -u vadeleke -- env bash << EOF
whoami
echo ~vadeleke

cd /home/vadeleke


sudo yum update -y
sudo systemctl enable docker 
sudo systemctl start docker
sudo docker pull prom/prometheus
sudo docker run -d --name=Prometheus -p 9090:9090 prom/prometheus
EOF
