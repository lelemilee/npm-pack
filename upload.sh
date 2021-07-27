#!/bin/bash

# upload script that upload *.tgz npm packages to local registry

usage() {
 echo "Usage: ${0} [-c CUSTOM_PATH]" >&2
 echo "Upload *.tgz npm packages to local registry" >&2
 echo "  -c CUSTOM_PATH  directory of *.tgz, defaults to ./artifacts/packages" >&2
 exit 1
} 

PACKAGE_PATH=./artifacts/packages

while getopts c OPTION
do
  case ${OPTION} in
    c)
      PACKAGE_PATH="${OPTARG}"
      ;;
    ?)
      usage
  esac
done 
# remove options
shift "$(( OPTIND - 1 ))" 

if [ "${#}" -ne 1 ]
then
  usage
fi

REPOSITORY=$1

npm login --registry=$REPOSITORY

for package in $PACKAGE_PATH/*.tgz
do
  echo $package
  npm publish --registry=$REPOSITORY $package 2>&1 1> /dev/null | tee -a npm_publish_error.log
done

echo ---------------------------------------
echo End of script. kthxbai.
echo ---------------------------------------