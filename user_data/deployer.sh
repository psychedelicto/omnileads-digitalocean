#!/bin/bash

apt update && apt install python2.7 -y && apt install python-pip -y
cd /opt && git clone https://gitlab.com/omnileads/ominicontacto.git
cd ./ominicontacto/deploy/ansible
