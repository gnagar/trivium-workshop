#!/bin/bash
if [[ $# -eq 0 ]] ; then
    echo 'Please supply the internal IP of this node to configure internal network. This node will join the swarm as a manager'
    exit 1
fi
yum -y update
# Swap
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
sysctl vm.swappiness=10
echo 'vm.swappiness=10' >> /etc/sysctl.conf
sysctl vm.vfs_cache_pressure=50
echo 'vm.vfs_cache_pressure=50' >> /etc/sysctl.conf
# Swap configured

# Private networking for Vultr
cat << EOF >> /etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE=eth1
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=static
IPADDR=$1
NETMASK=255.255.255.0
IPV6INIT=no
    MTU=1450
EOF
iptables -F 
# Private network configured

yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce
# start Docker
systemctl start docker
# install docker compose
curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
#install command completion
curl -L https://raw.githubusercontent.com/docker/compose/1.17.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
cat << EOF >> ~/.bash_profile
if [ -f /etc/bash_completion ]; then
. /etc/bash_completion
fi
EOF
cat << EOF >> /home/appworks/.bash_profile
if [ -f /etc/bash_completion ]; then
. /etc/bash_completion
fi
EOF
# Enable experimental features
cat << EOF >> /etc/docker/daemon.json
{
    "experimental": true
}
EOF
chmod 0600 /etc/docker/daemon.json
systemctl daemon-reload
systemctl restart docker
# To init docker swarm
# docker swarm init --advertise-addr $1
exit 0
