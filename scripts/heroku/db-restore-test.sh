#! /bin/bash
set -e

app=${1:-$APP_NAME}
heroku_app=${2:-$TEST_HEROKU_APP_NAME}
db_container=${3:-$DB_CONTAINER}

NO_COLOR='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

if [ -z "$app" ]
  then
    echo -e "${RED}No app_name provided${NO_COLOR}"
    echo "Usage: lib-db heroku-pull-test app_name heroku_app_name"
    exit 1
fi

if [ -z "$heroku_app" ]
  then
    echo -e "${RED}No heroku_app_name provided${NO_COLOR}"
    echo "Usage: lib-db heroku-pull-test app_name heroku_app_name"
    exit 1
fi

echo -e "${GREEN}Dropping ${app}_development...${NO_COLOR}"
docker exec -e PGUSER=postgres $db_container dropdb "${app}_development" --if-exists

echo -e "This will copy your .netrc to the docker container to allow it to connect to heroku"

docker cp ~/.netrc $db_container:/root

echo -e "${GREEN}Restoring backup of ${heroku_app} to ${db_container}"

docker exec -e PGUSER=postgres $db_container createdb "${app}_development"
docker exec -e PGUSER=postgres $db_container pg_restore --verbose --clean --no-acl --no-owner --dbname="${app}_development" latest.dump

echo -e "${GREEN}We just restored the test DB to ${app}_development from a local backup"

exit 0
