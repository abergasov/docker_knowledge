#!/usr/bin/env bash

env=${env:-dev}

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare "$param"="$2"
   fi

  shift
done

clean() {
  echo "stop containers";
  docker container stop knowledge_proxy_server knowledge_backend
  echo "drop containers"
  docker rm -v knowledge_proxy_server knowledge_backend
  echo "drop old images"
  docker rmi $(docker images -f dangling=true -q)
}

echo "Current env: ${env}"

clean

cat .env |
  sed -e 's/^KNOWLEDGE_PATH/DOCKER_REPO_PATH/' \
      -e 's/^ALLOW_IP/ALLOW_IP/' \
      -e 's/^VERSION/GIT_BOOK_VERSION/' >.env.tmp

mv .env.tmp .env

# shellcheck disable=SC2046
export $(grep -v '^#' .env | xargs)

# edit nginx
# shellcheck disable=SC2002
cat configs/nginx/nginx.conf.sample | sed -e "s/IP_DATA/${ALLOW_IP}/g" > configs/nginx/nginx.conf

# gitbook from container will create work directories. to keep it clean - copy repository to tmp directory
# erase first
DOCKER_REPO_PATH=${DOCKER_REPO_PATH%/}
rm -rf gitbook/copy_repo && mkdir "gitbook/copy_repo" && touch gitbook/copy_repo/.gitkeep
cp -R "${DOCKER_REPO_PATH}/"* gitbook/copy_repo/

echo "Repo path: $DOCKER_REPO_PATH"
if [ "$env" == "daemon" ]; then
  docker-compose -f docker-compose.yml pull
  docker-compose -f docker-compose.yml up --build -d
else
  docker-compose -f docker-compose.yml pull
  docker-compose -f docker-compose.yml up --build
fi
