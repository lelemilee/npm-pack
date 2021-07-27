packageFile="${1:-./package.json}"
artifacts_dir="$(pwd)/artifacts"
nodeVersion=12
nodeSassVersion=4.14.1
dockerTempContainerName=npm_package_downloader

# echo $packageFile
mkdir -p $artifacts_dir/packages
cp $packageFile $artifacts_dir
cd $artifacts_dir

rm package-lock.json

echo ---------------------------------------
echo Building package-lock.json
echo ---------------------------------------
echo

npm install --package-lock-only --no-audit --loglevel=error
echo Before installation, there are $(ls packages | wc -l) packages in the packages
mv package-lock.json packages
cd packages

echo
echo ---------------------------------------
echo Getting full list of dependencies
echo ---------------------------------------
echo

package_args=`python $artifacts_dir/../get_dependencies.py ./package-lock.json` || (echo "Error: $package_args" && exit 1)
python /get_dependencies.py ./package-lock.json > $artifacts_dir/deps.txt
echo There are $(echo "$package_args" | wc -w) packages to pack

echo
echo ---------------------------------------
echo Packing all dependencies
echo ---------------------------------------
echo

npm pack $package_args --loglevel error > /dev/null
if [ $? -ne 0 ]
then
  echo Trying again
  npm pack $package_args --loglevel error > /dev/null
fi

mv package-lock.json $artifacts_dir
echo Successfully downloaded and packed `ls | wc -l` packages
cd $artifacts_dir
rm package.json
