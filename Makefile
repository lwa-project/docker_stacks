# Setup
SHELL:=bash
OWNER:=lwaproject

# Images
ALL_STACKS:=base \
	session_schedules \
	raw_data \
	baseline \
	pulsar \
	jupyter

ALL_IMAGES:=$(ALL_STACKS)

help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@echo "lwa-project/docker_stacks"
	@echo "========================="
	@echo "Replace % with a stack directory name (e.g., make build/raw_data)"
	@echo
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


build/%: DARGS?=
build/%: ## build the latest image for a stack
	docker build $(DARGS) --rm --force-rm \
		--tag $(OWNER)/lsl:$(notdir $@) \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
        	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		./$(notdir $@)
	@echo -n "Built image size: "
	@docker images $(OWNER)/lsl:$(notdir $@) --format "{{.Size}}"

build-all: $(foreach I,$(ALL_IMAGES), build/$(I) ) ## build all stacks

cont-clean-all: cont-stop-all cont-rm-all ## clean all containers (stop + rm)

cont-stop-all: ## stop all containers
	@echo "Stopping all containers ..."
	-docker stop -t0 $(shell docker ps -a -q) 2> /dev/null

cont-rm-all: ## remove all containers
	@echo "Removing all containers ..."
	-docker rm --force $(shell docker ps -a -q) 2> /dev/null

img-clean: img-rm-dang img-rm ## clean dangling and LSL images

img-list: ## list LSL images
	@echo "Listing $(OWNER) images ..."
	docker images "$(OWNER)/*"

img-rm:  ## remove LSL images
	@echo "Removing $(OWNER) images ..."
	-docker rmi --force $(shell docker images --quiet "$(OWNER)/*") 2> /dev/null

img-rm-dang: ## remove dangling images (tagged None)
	@echo "Removing dangling images ..."
	-docker rmi --force $(shell docker images -f "dangling=true" -q) 2> /dev/null

pull/%: DARGS?=
pull/%: ## pull an LSL image
	docker pull $(DARGS) $(OWNER)/lsl:$(notdir $@)

run/%: DARGS?=
run/%: ## run a bash in interactive mode in a stack
	docker run -it --rm $(DARGS) $(OWNER)/lsl:$(notdir $@) $(SHELL)

run-sudo/%: DARGS?=
run-sudo/%: ## run a bash in interactive mode as root in a stack
	docker run -it --rm -u root $(DARGS) $(OWNER)/lsl:$(notdir $@) $(SHELL)
