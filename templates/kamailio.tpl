#/bin/bash

RELEASE=develop
PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

yum update -y
yum install python3-pip python3 epel-release git -y
pip3 install pip --upgrade
pip3 install 'ansible==2.9.2'

sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

git clone https://gitlab.com/omnileads/omlkamailio.git
cd omlkamailio
git checkout $RELEASE
cd ansible

sed -i "s/asterisk_hostname=.*/asterisk_hostname=x.x.x.x" ./inventory
sed -i "s/kamailio_hostname=.*/kamailio_hostname=$PRIVATE_IPV4" ./inventory
sed -i "s/redis_hostname=.*/reis_hostname=${redis_host}" ./inventory
sed -i "s/rtpengine_hostname=.*/rtpengine_hostname=${rtpengine_host}" ./inventory
echo "certs_location=../certs" >> ./inventory

ansible-playbook kamailio.yml -i inventory --extra-vars "repo_location=$(pwd)/.. kamailio_version=$(cat ../.package_version)"
