#! /bin/bash
set -e
source $(dirname ${BASH_SOURCE[0]})/utils

app=${1:-$APP_NAME}
heroku_app=${2:-$TEST_HEROKU_APP_NAME}
db_container=${3:-$DB_CONTAINER}

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

copy_netrc_to_docker_container "$db_container"
verify_if_heroku_is_logged "$db_container"

echo -e "${GREEN}Creating a backup for download from ${heroku_app}"
docker exec -e PGUSER=postgres $db_container heroku pg:backups:capture --app $heroku_app

exit 0
