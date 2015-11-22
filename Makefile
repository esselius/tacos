.DEFAULT_GOAL:=test

WORKDIR:=/usr/src/app

TEST_FILES:=$(wildcard test/*_test.rb)
TEST_COMMAND:=ruby -I./ $(foreach file,$(TEST_FILES),-r$(file)) -e exit

NAME:=$(shell basename $$PWD)
SAFE_DOCKER_RUN:=docker run --rm -it --net=none $(NAME)

Gemfile.lock: Gemfile
	docker build -t $(NAME) .
	docker create --name $(NAME) $(NAME) cmd
	docker cp $(NAME):$(WORKDIR)/Gemfile.lock .
	docker rm $(NAME)

.PHONY: build
build: Gemfile.lock
	docker build -t $(NAME) -f Dockerfile.dev .

.PHONY: test
test: build
	$(SAFE_DOCKER_RUN) $(TEST_COMMAND)

.PHONY: test-local
test-local:
	$(TEST_COMMAND)

.PHONY: lint
lint: build
	$(SAFE_DOCKER_RUN) rubocop

.PHONY: base
base:
	cp -r tacos/files/. .
	cat tacos/files/app.rb | sed "s/NAME/$(NAME)/" > app.rb
	cat tacos/files/Dockerfile.dev | sed "s/NAME/$(NAME)/" > Dockerfile.dev
