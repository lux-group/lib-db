#! /bin/bash
set -e
set -o errexit   # abort on nonzero exitstatus
set -o pipefail  # don't hide errors within pipes

app=${1:-$APP_NAME}
db_container=${2:-$DB_CONTAINER}

NO_COLOR='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

if [ -z "$app" ]
  then
    echo -e "${RED}No app_name provided${NO_COLOR}"
    echo "Usage: lib-db snapshot app_name db_container"
    exit 1
fi

if [ -z "$db_container" ]
  then
    echo -e "${RED}Missing DB_CONTAINER env variable${NO_COLOR}"
    echo "Usage: lib-db snapshot app_name db_container"
    exit 1
fi

docker exec -e PGUSER=postgres $db_container dropdb "${app}_development_snapshot" --if-exists
docker exec -e PGUSER=postgres $db_container createdb -T "${app}_development" "${app}_development_snapshot"

echo -e "${GREEN}We've made a copy of ${app}_development at ${app}_development_snapshot.
You can restore it with yarn db:snapshot:restore${NO_COLOR}"
