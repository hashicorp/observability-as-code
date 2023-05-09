ts := $(shell /bin/date "+%s")

check-variables:
ifndef PROJECT_ID
	$(error PROJECT_ID is undefined)
endif

build: check-variables
	packer build -var 'project_id=${PROJECT_ID}' -var 'zone=${ZONE}' build.pkr.hcl

force-build: check-variables
	packer build -force -var 'project_id=${PROJECT_ID}' -var 'zone=${ZONE}' build.pkr.hcl
