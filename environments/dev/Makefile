.DEFAULT_GOAL := $(ENV).tfplan

GIT_FILES := $(if $(wildcard .git),$(shell git ls-files),$(patsubst ./%,%,$(shell find . -type f | grep -vE '^(\./)?\.git/')))
TF_FILES := $(filter-out $(wildcard *.tfvars.yml) $(wildcard terraform.tfvars.json),$(GIT_FILES))

tfvars_yaml_sources := $(wildcard *.tfvars.yml)
tfvars_json_objects := $(tfvars_yaml_sources:.yml=.json)

# If you think this looks stupid, it's there for a reason so that if the command fails
# for something like invalid yml format, then the json file gets removed, so `make`
# knows that it needs to re-generate on the next run
# trust me you *very* likely want it to behave this way to prevent pain
%.tfvars.json: %.tfvars.yml
	yq -o=json eval $(ENV).tfvars.yml > $(ENV).tfvars.json

destroy-$(ENV).tfplan: $(ENV).tfvars.json $(TF_FILES) workspace
	terraform plan -var-file $< -destroy -out $@

%.tfplan: %.tfvars.json $(TF_FILES) workspace
	terraform plan -var-file $< -out $@

apply: $(ENV).tfplan
	terraform apply $<

init: generate_outputs
	$(if $(wildcard .terraform),,terraform init -backend-config=./$(ENV)-bucket.conf)

generate_outputs:
	@echo "bucket=\"$$(yq eval '.bucket_name' $(ENV).tfvars.yml)\"" > $(ENV)-bucket.conf || true
	@echo "Variable 'bucket_name' extracted from $(ENV).tfvars.yml and written to $(ENV)-bucket.conf used for init in runtime"

tf_lock_file := .terraform.lock.hcl
upgrade:
	$(if $(wildcard $(tf_lock_file)),cp $(tf_lock_file) $(addsuffix .bak,$(tf_lock_file)))
	terraform init -upgrade

workspace: init
	terraform workspace select $(ENV) || terraform workspace new $(ENV)

clean_json_files := $(wildcard $(tfvars_json_objects) terraform.tfvars.json)
clean_plan_files := $(wildcard *.tfplan)
clean:
	$(if $(clean_json_files),rm $(clean_json_files))
	$(if $(clean_plan_files),rm $(clean_plan_files))

apply-only: workspace
	terraform apply "$(ENV).tfplan"

plan: $(ENV).tfplan

plan-destroy: destroy-$(ENV).tfplan

destroy: destroy-$(ENV).tfplan
	terraform apply $<

.PHONY: apply apply-only workspace generate_outputs init clean plan plan-destroy upgrade graph
