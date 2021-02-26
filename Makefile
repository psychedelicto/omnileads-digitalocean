.PHONY: all

DEFAULT_TARGET: all

TF_BIN ?= terraform

all: init plan

plan:
	cd environments/$(ENV) && terraform plan
#
apply:
	cd environments/$(ENV) && terraform apply
#
destroy:
	cd environments/$(ENV) && terraform destroy
	rm -rf environments/$(ENV)

init:
	utils/env_setup.sh prepare_deploy_links $(ENV) $(DIALER)
