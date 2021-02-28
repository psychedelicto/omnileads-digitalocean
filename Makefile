.PHONY: all

DEFAULT_TARGET: all

TF_BIN ?= terraform

all: init plan

plan:
	cd ../$(ENV) && terraform plan

apply:
	cd ../$(ENV) && terraform apply

destroy:
	cd ../$(ENV) && terraform destroy

init:
	utils/env_setup.sh prepare_deploy_links $(ENV) $(TYPE)

delete:
	rm -rf ../$(ENV)
