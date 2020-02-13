#! /bin/bash
set -e

APP_NAME=$1
HEROKU_APP=$2

NO_COLOR='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

if [ -z "$APP_NAME" ]
  then
    echo -e "${RED}No app_name provided${NO_COLOR}"
    echo "Usage: lib-db heroku-pull-test app_name heroku_app_name"
    exit 1
fi

if [ -z "$HEROKU_APP" ]
  then
    echo -e "${RED}No heroku_app_name provided${NO_COLOR}"
    echo "Usage: lib-db heroku-pull-test app_name heroku_app_name"
    exit 1
fi

echo -e "${GREEN}Dropping ${APP_NAME}_development...${NO_COLOR}"
dropdb --if-exists "${APP_NAME}_development"

echo -e "${GREEN}Pulling test DB from ${HEROKU_APP} to ${APP_NAME}_development${NO_COLOR}"
heroku pg:pull DATABASE_URL "postgresql://@localhost/${APP_NAME}_development" --app $HEROKU_APP

echo -e "${GREEN}We just pulled the test DB to ${APP_NAME}_development

You might like to run yarn db:snapshot, so you can later restore this fresh test DB without re-downloading it."

exit 0
