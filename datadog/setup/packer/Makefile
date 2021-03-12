ts := $(shell /bin/date "+%s")

check-variables:
ifndef PROJECT
  $(error PROJECT is undefined)
endif
ifndef ZONE
  $(error ZONE is undefined)
endif

build: check-variables
	packer build -var 'project_id=${PROJECT}' -var 'zone=${ZONE}' -var 'network=$(or $(NETWORK),default)' packer.json

force-build: check-variables
	packer build -force -var 'project_id=${PROJECT}' -var 'zone=${ZONE}' -var 'network=$(or $(NETWORK),default)' packer.json
