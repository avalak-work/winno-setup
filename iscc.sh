#!/usr/bin/env bash
set -eu

# --rm                             Automatically remove the container when it exits
# -i, --interactive                    Keep STDIN open even if not attached
# -t, --tty                            Allocate a pseudo-TTY

docker run \
  --rm -it \
  -v "${PWD}":/Data \
  -u "$(id -u "${USER}")":"$(id -g "${USER}")" \
  ghcr.io/avalak-work/winno-setup:latest \
  "${@}"
