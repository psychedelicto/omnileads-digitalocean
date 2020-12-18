#!/bin/bash

apt update
apt install redis-server -y

PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

sed -i "s/bind 127.0.0.1/bind "$PRIVATE_IPV4"/g" /etc/redis/redis.conf

systemctl restart redis.service
