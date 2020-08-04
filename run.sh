#!/usr/bin/env bash

clean() {
  echo "stop containers";
  docker container stop knowledge_proxy_server knowledge_backend
  echo "drop containers"
  docker rm -v knowledge_proxy_server knowledge_backend
}

clean

cat .env |
  sed -e 's/^KNOWLEDGE_PATH/DOCKER_REPO_PATH/' \
      -e 's/^VERSION/GIT_BOOK_VERSION/' >.env.tmp

mv .env.tmp .env

# shellcheck disable=SC2046
export $(grep -v '^#' .env | xargs)


# gitbook from container will create work directories. to keep it clean - copy repository to tmp directory
# erase first
rm -rf gitbook/copy_repo && mkdir "gitbook/copy_repo" && touch gitbook/copy_repo/.gitkeep
cp -R "${DOCKER_REPO_PATH}"* gitbook/copy_repo/

echo "Repo path: $DOCKER_REPO_PATH"
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml up --build