#!/bin/bash
set -e

export HOME=/root

# Hack to make sure we don't start installing packages until the filesystem is available.
echo "waiting 180 seconds for cloud-init to update /etc/apt/sources.list"
timeout 180 /bin/bash -c \
  'until stat /var/lib/cloud/instance/boot-finished 2>/dev/null; do echo waiting ...; sleep 1; done'

# Install packages.
export DEBIAN_FRONTEND=noninteractive

apt-get -y install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"

apt-get update

apt-get -y install docker-ce

curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

apt-get -y install git wget

git clone https://github.com/DataDog/ecommerce-workshop.git

curl -L https://github.com/buger/goreplay/releases/download/v1.2.0/gor_v1.2.0_x64.tar.gz -o gor_v1.2.0_x64.tar.gz
tar -xf gor_v1.2.0_x64.tar.gz
mv gor /usr/local/bin/gor
rm -rf gor_v1.2.0_x64.tar.gz

systemctl disable gor
