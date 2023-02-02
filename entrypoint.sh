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
case "${1?Arg REQUIRED: i|iscc|u|unp|unpack}" in
  i|iscc)
    exec wine "$(winepath -w "/wine/drive_c/inno/ISCC.exe")" "${_args[@]:1}"
    ;;
  u|unp|unpack)
    exec wine "$(winepath -w "/wine/drive_c/inno/innounp.exe")" "${_args[@]:1}"
    ;;
  help|*)
    show_usage
    ;;
esac

