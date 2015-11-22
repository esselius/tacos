#!/usr/bin/env bash

[[ "$TRACE" ]] && set -x
set -eou pipefail

main() {
  local image="$1"; shift
  local command="$@"

  if image_not_present; then
    build
  else
    if no_command; then
      build
    fi
  fi

  exec ${command}
}

image_not_present() {
  [[ $(docker inspect $image) == "[]" ]]
}

no_command() {
  [[ -z ${command} ]]
}

build() {
  docker build -t ${image} .
  touch Dockerfile
}

main $@
