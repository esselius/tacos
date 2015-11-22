.DEFAULT_GOAL:=test

NAME:=$(shell basename $$PWD)

TACOS_PATH=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

WORKDIR:=/usr/src/app

TEST_FILES:=$(wildcard test/*_test.rb)
TEST_COMMAND:=ruby -I./ $(foreach file,$(TEST_FILES),-r$(file)) -e exit

SAFE_DOCKER_RUN:=docker run --rm -it --net=none $(NAME)

Gemfile.lock: Gemfile
	docker build -t $(NAME) .
	docker create --name $(NAME) $(NAME) cmd
	docker cp $(NAME):$(WORKDIR)/Gemfile.lock .
	docker rm $(NAME)

.PHONY: build
build: Gemfile.lock
	docker build -t $(NAME) .

.PHONY: test
test: build
	$(SAFE_DOCKER_RUN) $(TEST_COMMAND)

.PHONY: test-local
test-local:
	$(TEST_COMMAND)

.PHONY: lint
lint: build
	$(BUILDER) $(DOCKER_RUN) rubocop
