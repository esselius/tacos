.DEFAULT_GOAL:=test

TACOS_PATH=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

DOCKER_IMAGE:=tacos
CONTAINER_WORKDIR:=/usr/src/app

TEST_FILES:=$(wildcard test/*_test.rb)
TEST_COMMAND:=ruby -I./ $(foreach file,$(TEST_FILES),-r$(file)) -e exit

BUILDER:=$(TACOS_PATH)/Dockerfile.sh $(DOCKER_IMAGE)
DOCKER_RUN:=docker run --rm -it --net=none -v $(PWD):$(CONTAINER_WORKDIR) $(DOCKER_IMAGE)

Gemfile.lock: Gemfile
	$(BUILDER)
	$(TACOS_PATH)/Gemfile.lock.sh $(DOCKER_IMAGE) $(CONTAINER_WORKDIR)

test: Gemfile.lock
	$(BUILDER) $(DOCKER_RUN) $(TEST_COMMAND)

test-local:
	$(TEST_COMMAND)

lint: Dockerfile
	$(BUILDER) $(DOCKER_RUN) rubocop
