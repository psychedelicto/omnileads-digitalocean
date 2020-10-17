#!/bin/bash

apt update && apt install python3-pip -y && apt install ansible -y
cd /opt && git clone https://github.com/psychedelicto/astgw4oml.git
cd ./astgw4oml/deploy/asterisk-ansible-role/
ansible-playbook asterisk.yml -i inventory
reboot
