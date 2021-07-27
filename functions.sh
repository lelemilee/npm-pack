#!/bin/bash

# common functions that are used across the scripts

usage() {
  echo "Usage: ${0} [-v]"
  echo " -v Increase verbosity."
  exit 1
}

log() {
  # This function sends a message to standard output if VERBOSE is true.
  local MESSAGE=${@}
  if [ "${VERBOSE}" = 'true' ]
  then
    echo "${MESSAGE}"
  fi
}
