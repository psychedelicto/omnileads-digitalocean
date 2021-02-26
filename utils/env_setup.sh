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
  local type=$2

  if [ ! -d ${ENVS_DIR}/${environment} ]; then
    mkdir ${ENVS_DIR}/${environment}/
  fi
  undo_links ${environment}
  cd ${ENVS_DIR}/${environment}/

  cp ../hcl_template/vars.auto.tfvars ./
  cp ../hcl_template/provider.tf ./
  ln -s ../hcl_template/versions.tf ./
  ln -s ../hcl_template/main.tf ./
  ln -s ../hcl_template/vars.tf ./

  if [ "${type}" == "aio" ] || [ "${type}" == "AIO" ]; then
    ln -s ../hcl_template/omlapp_aio.tf ./
  elif [ "${type}" == "cluster" ] || [ "${type}" == "CLUSTER" ]; then
    ln -s ../hcl_template/redis.tf ./
    ln -s ../hcl_template/rtpengine.tf ./
    ln -s ../hcl_template/pgsql.tf ./
    ln -s ../hcl_template/omlapp_not_dialer.tf ./
  elif [ "${type}" == "cluster_dialer" ] || [ "${dialer}" == "CLUSTER_DIALER" ]; then
    ln -s ../hcl_template/redis.tf ./
    ln -s ../hcl_template/rtpengine.tf ./
    ln -s ../hcl_template/pgsql.tf ./
    ln -s ../hcl_template/omlapp.tf ./
    ln -s ../hcl_template/dialer.tf ./
    ln -s ../hcl_template/mysql.tf ./
  fi
  sed -i "s/customer-name/$environment/" ./vars.auto.tfvars
  sed -i "s/customer-name/$environment/" ./provider.tf

  sleep 5
  terraform init
}

undo_links() {
  links=$(find ${ENVS_DIR}/${1} -type l -path "${ENVS_DIR}/${1}/.terraform/*" -prune -o -type l -print)
  #echo $links
  for file in ${links}; do
    unlink ${file}
  done
}

$@
