#!/usr/bin/env bash

[[ "$TRACE" ]] && set -x
set -eou pipefail

main() {
  declare image="$1" path="$2"

  local container=$(docker create ${image} cmd)
  docker cp ${container}:${path}/Gemfile.lock ${PWD}/Gemfile.lock
  docker rm ${container}
}

main $@
