#! /bin/bash
set -e
source $(dirname ${BASH_SOURCE[0]})/utils

app=${1:-$APP_NAME}
heroku_app=${2:-$TEST_HEROKU_APP_NAME}
db_container=${3:-$DB_CONTAINER}

NO_COLOR='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

exclude_tables_param=""
if [ -n "$EXCLUDE_TABLES" ]
  then
  exclude_tables_param="--exclude-table-data=\"$EXCLUDE_TABLES\""
fi

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

copy_netrc_to_docker_container "$db_container"
verify_if_heroku_is_logged "$db_container"

echo -e "${GREEN}Dropping ${app}_development...${NO_COLOR}"
docker exec -e PGUSER=postgres $db_container dropdb "${app}_development" --if-exists

echo -e "${GREEN}Pulling test DB from ${heroku_app} to ${app}_development${NO_COLOR}"
docker exec -e PGUSER=postgres $db_container heroku pg:pull DATABASE_URL "${app}_development" --app $heroku_app $exclude_tables_param

echo -e "${GREEN}We just pulled the test DB to ${app}_development

You might like to run yarn db:snapshot, so you can later restore this fresh test DB without re-downloading it."

exit 0
