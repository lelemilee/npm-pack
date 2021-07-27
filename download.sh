# this script download npm packages and its respective dependency from `package.json` as *.tgz files into artifacts/packages folder

. ./functions.sh

while getopts v OPTION
do
  case ${OPTION} in
    v)
      VERBOSE='true'
      log 'Verbose mode on.'
      ;;
    ?)
      usage
  esac
done 

# remove options
shift "$(( OPTIND - 1 ))" 

if [ ${#} -gt 0 ]
then
  usage
fi

packageFile="${1:-./package.json}"
nodeVersion=12
nodeSassVersion=4.14.1
dockerTempContainerName=npm_package_downloader
DOCKER_ARTIFACTS_DIR="/artifacts"
ARTIFACTS_DIR="//artifacts"
DOCKER_PACK_SCRIPT="//docker_pack.sh"

echo ---------------------------------------
echo Updating node-sass via Docker container
echo ---------------------------------------
# echo $packageFile
docker run --name $dockerTempContainerName -v $(pwd -W)/artifacts/:$DOCKER_ARTIFACTS_DIR -e TAG=v$nodeSassVersion -d -it node:$nodeVersion
docker cp ./functions.sh $dockerTempContainerName:/functions.sh
docker cp ./docker_update_node_sass.sh $dockerTempContainerName:/update.sh
docker cp ./docker_pack.sh $dockerTempContainerName:/docker_pack.sh
docker cp $packageFile $dockerTempContainerName:$DOCKER_ARTIFACTS_DIR/package.json
docker cp ./get_dependencies.py $dockerTempContainerName:/get_dependencies.py
docker exec -ti $dockerTempContainerName sh ./update.sh
log Update for node-sass via Docker container completed successfully

docker exec -ti $dockerTempContainerName bash $DOCKER_PACK_SCRIPT $ARTIFACTS_DIR $VERBOSE

echo ---------------------------------------
echo Stopping and removing temp container
echo ---------------------------------------

docker stop $dockerTempContainerName
docker rm $dockerTempContainerName
