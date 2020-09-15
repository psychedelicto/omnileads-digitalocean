

curl -X POST "https://api.digitalocean.com/v2/droplets" \
      -d'{"name":"tenant2-omlapp","region":"sfo2","size":"s-1vcpu-1gb","vpc_uuid":"c0a8c0c2-477b-4352-9406-890ceacbe297","image":"ubuntu-18-04-x64","user_data":
"#!/bin/bash

apt update && apt install python-pip -y
git clone https://gitlab.com/omnileads/pstngw4oml.git
export HOSTNAME=$(curl -s http://169.254.169.254/metadata/v1/hostname)
export PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
echo Droplet: $HOSTNAME, IP Address: $PUBLIC_IPV4 > /usr/share/nginx/html/index.html",
      "ssh_keys":[ < ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDgyDsOYKLPYhC3XqAbMxOtyrM3Wp2GBJOWZYA7rInEprpR2DE4Rnq2Ge6B5d6vjuLYD/vbmZNTTydt+PQ96nxsO88ssiX/IHcKn7hK1VUbCsoSWsWq/XBxAunPr7nxZjm2EWGxp0GA6LiCns9AOeaAPNXsZ8el8RvTld3w0V3n60xON/oPrQIi9U8aZLxsapKs8hzRlkIoiIBYS8r0MMFA+TLBxCnbyGZ1a+lgeFwgB52Xb9iwkeJNgI1IEBJYFBdssC3QpvKMBSiJFoyaV/LUmjD/CygIj+fVx3ZHGwWnfYQD200dwwSEYlXdHgqteGPZm96svj7C01zUSu0aie2lKTmIKqksQLUIIsGuj2wBs3ZqnemqrNK2tCU9W0LMjtQjOmojqNpV0HKxTmaSWHeRbQitVskJ0Pt69klJNn71IHt3611d5Cd8VM4oTMdpOXJDqUxYLbdhQE9SKNNCEbBCygDJ7THRMHeX4OmlOH2A9Iqu/6wOIZ9oIzRRfzqzq8U= fpignataro@pop-os
 > ]}' \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json"
