#!/bin/bash

set -eo pipefail
PATH=$PATH:~/.local/bin
ENVS_DIR=../

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

  cp ../omnileads-digitalocean/hcl_template/vars.auto.tfvars ./
  cp ../omnileads-digitalocean/hcl_template/provider.tf ./
  ln -s ../omnileads-digitalocean/hcl_template/versions.tf ./
  ln -s ../omnileads-digitalocean/hcl_template/main.tf ./
  ln -s ../omnileads-digitalocean/hcl_template/vars.tf ./

  if [ "${type}" == "aio" ] || [ "${type}" == "AIO" ]; then
    ln -s ../omnileads-digitalocean/hcl_template/omlapp_aio.tf ./
  elif [ "${type}" == "cluster_a" ] || [ "${type}" == "CLUSTER_A" ]; then
    ln -s ../omnileads-digitalocean/hcl_template/rtpengine.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/pgsql.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/omlapp_a.tf ./
  elif [ "${type}" == "cluster_c" ] || [ "${dialer}" == "CLUSTER_B" ]; then
    ln -s ../omnileads-digitalocean/hcl_template/rtpengine.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/pgsql.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/omlapp_b.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/dialer.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/mysql.tf ./
  elif [ "${type}" == "cluster_all" ] || [ "${dialer}" == "CLUSTER_C" ]; then
    ln -s ../omnileads-digitalocean/hcl_template/redis.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/rtpengine.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/pgsql.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/omlapp_c.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/kamailio.tf ./
  elif [ "${type}" == "cluster_all" ] || [ "${dialer}" == "CLUSTER_ALL" ]; then
    ln -s ../omnileads-digitalocean/hcl_template/redis.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/rtpengine.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/pgsql.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/omlapp.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/dialer.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/mysql.tf ./
    ln -s ../omnileads-digitalocean/hcl_template/kamailio.tf ./
  fi
  sed -i "s/customer-name/$environment/" ./vars.auto.tfvars
  sed -i "s/customer-name/$environment/" ./provider.tf

  sed -i "s/spaces-key-id/$(echo $TF_VAR_spaces_key)/" ./provider.tf
  sed -i "s/spaces-key-secret/$(echo $TF_VAR_spaces_secret_key)/" ./provider.tf


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
