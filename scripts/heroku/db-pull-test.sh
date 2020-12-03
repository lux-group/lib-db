#! /bin/bash
set -e

app=${1:-$APP_NAME}
heroku_app=${2:-$TEST_HEROKU_APP_NAME}
dev_pg_port=${PGPORT:-"5432"}

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
dropdb --if-exists --port $dev_pg_port "${app}_development"

echo -e "${GREEN}Pulling test DB from ${heroku_app} to ${app}_development${NO_COLOR}"
heroku pg:pull DATABASE_URL "postgresql://@localhost:$dev_pg_port/${app}_development" --app $heroku_app

echo -e "${GREEN}We just pulled the test DB to ${app}_development

You might like to run yarn db:snapshot, so you can later restore this fresh test DB without re-downloading it."

exit 0
