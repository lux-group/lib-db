#! /bin/bash
set -e

app=${1:-$APP_NAME}
heroku_app=${2:-$TEST_HEROKU_APP_NAME}
db_container=${3:-$DB_CONTAINER}
strategy=${4:-$STRATEGY}

NO_COLOR='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

if [ -z "$app" ]
  then
    echo -e "${RED}No app_name provided${NO_COLOR}"
    echo "Usage: lib-db heroku-backup-test app_name heroku_app_name"
    exit 1
fi

if [ -z "$heroku_app" ]
  then
    echo -e "${RED}No heroku_app_name provided${NO_COLOR}"
    echo "Usage: lib-db heroku-backup-test app_name heroku_app_name"
    exit 1
fi

echo -e "${GREEN}Dropping ${app}_development...${NO_COLOR}"
docker exec -e PGUSER=postgres $db_container dropdb "${app}_development" --if-exists

echo -e "This will copy your .netrc to the docker container to allow it to connect to heroku"

docker cp ~/.netrc $db_container:/root

echo -e "${GREEN}Backing up test DB from ${heroku_app} to ${db_container}"

if [ "$STRATEGY" == "backup" ]
  then
    docker exec -e PGUSER=postgres $db_container heroku pg:backups:capture --app $heroku_app
    docker exec -e PGUSER=postgres $db_container heroku pg:backups:download --app $heroku_app
    echo -e "${GREEN}We just created a backup of ${heroku_app} and downloaded it locally to ${db_container}"
fi

if [ "$STRATEGY" == "download" || "$STRATEGY" == "" ]
  then
    docker exec -e PGUSER=postgres $db_container heroku pg:backups:download --app $heroku_app
    echo -e "${GREEN}We just downloaded a backup of ${heroku_app} locally to ${db_container}. If the backup is not recent enough, change your STRATEGY to backup."
fi

exit 0
