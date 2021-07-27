#!/bin/bash

. ./functions.sh 

ARTIFACTS_DIR="$1"
VERBOSE="$2"
cd $ARTIFACTS_DIR

rm package-lock.json 2> /dev/null

echo ---------------------------------------
echo Building package-lock.json
echo ---------------------------------------
log

mkdir packages 2> /dev/null
npm install --package-lock-only --no-audit --loglevel=error
log Before installation, there are $(ls packages | wc -l) packages in the packages folder
mv package-lock.json packages
cd packages
package_args=`python /get_dependencies.py ./package-lock.json` || (echo "Error: $package_args" && exit 1)
python /get_dependencies.py ./package-lock.json > $ARTIFACTS_DIR/deps.txt
log There are $(echo "$package_args" | wc -w) packages to pack

log
echo ---------------------------------------
echo Packing all dependencies
echo ---------------------------------------
log

# read -a s <<< "$package_args"
# batch_size=500
# for ((i=0; i<=${#s[@]}; i+=batch_size)); do
#     npm pack ${s[@]:i:batch_size} --loglevel error > /dev/null
# done

npm pack $package_args --loglevel error > /dev/null 2>&1 | tee error.log
if [ $? -ne 0 ]
then
  log Trying again because of random error 400, the same package never fails twice -.-
  log If E400 again for a package in this next round, check that the packages folder already has it.
  log Alternatively, npm pack it manually.
  npm pack $package_args --loglevel error > /dev/null 2>&1 | tee -a error.log
fi

mv error.log $ARTIFACTS_DIR
mv package-lock.json $ARTIFACTS_DIR
echo Successfully downloaded and packed `ls | wc -l` packages
cd $ARTIFACTS_DIR
rm package.json
