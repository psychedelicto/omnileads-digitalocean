#!/bin/bash

set -eo pipefail
PATH=$PATH:~/.local/bin
ENVS_DIR=environments

if [ -z "${1}" ]; then
  echo "Usage:"
  echo -e "\t> ./aws_utils.sh prepare_deploy_links <environment>"
fi

prepare_deploy_links() {

  local environment=$1
  local dialer=$2

  mkdir ${ENVS_DIR}/${environment}/
  cd ${ENVS_DIR}/${environment}/

  ln -s ../hcl_template/versions.tf ./
  ln -s ../hcl_template/main.tf ./
  ln -s ../hcl_template/vars.tf ./
  ln -s ../hcl_template/redis.tf ./
  ln -s ../hcl_template/rtpengine.tf ./
  ln -s ../hcl_template/pgsql.tf ./
  ln -s ../hcl_template/omlapp.tf ./
  # (if dialer)
  ln -s ../hcl_template/dialer.tf ./
  ln -s ../hcl_template/mysql.tf ./

  cp ../hcl_template/vars.auto.tfvars ./
  cp ../hcl_template/provider.tf ./

  sed -i "s/customer-name/$environment/" ./vars.auto.tfvars
  sed -i "s/customer-name/$environment/" ./provider.tf

  sleep 5
  terraform init
}

$@
