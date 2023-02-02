#!/usr/bin/env bash
set -eu
# set -x

show_usage () {
  cat << EOF
Usage: ${0##*/} (inno|unpack) [args]

# Description:

* Inno Setup 6
* Inno Unpack

EOF

}
_args=( "${@}" )
case "${1}" in
  inno)
    exec wine "$(winepath -w "/wine/drive_c/inno/ISCC.exe")" "${_args[@]:1}"
    ;;
  unpack)
    exec wine "$(winepath -w "/wine/drive_c/inno/innounp.exe")" "${_args[@]:1}"
    ;;
  help|*)
    show_usage
    ;;
esac

