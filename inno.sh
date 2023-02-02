#!/usr/bin/env bash
set -eu

# --rm                                 Automatically remove the container when it exits
# -i, --interactive                    Keep STDIN open even if not attached
# -t, --tty                            Allocate a pseudo-TTY

image=${IMAGE:-ghcr.io/avalak-work/winno-setup:latest}
if [ "${ACTION:-}" == "update" ]; then
  echo "Pulling image: ${image}"
  docker pull "${image}"
fi

docker run \
  --rm -it \
  -v "${PWD}":/Data \
  -u "$(id -u "${USER}")":"$(id -g "${USER}")" \
  "${image}" \
  "${@}"
