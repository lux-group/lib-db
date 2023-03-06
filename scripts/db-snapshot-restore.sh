#! /bin/bash
set -e
set -o errexit   # abort on nonzero exitstatus
set -o pipefail  # don't hide errors within pipes

app=${1:-$APP_NAME}
db_container=${3:-$DB_CONTAINER}

NO_COLOR='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

if [ -z "$app" ]
  then
    echo -e "${RED}No app_name provided${NO_COLOR}"
    echo "Usage: lib-db snapshot-restore app_name"
    exit 1
fi

if [ -z "$db_container" ]
  then
    echo -e "${RED}Missing DB_CONTAINER env variable${NO_COLOR}"
    exit 1
fi

# check if DB exists - from https://stackoverflow.com/a/17757560/1373987
if [ "$(docker exec -e PGUSER=postgres $db_container psql -tAc "SELECT 1 FROM pg_database WHERE datname='${app}_development_snapshot'" )" != '1' ]
then
  echo -e "${RED}${app}_development_snapshot does not exist.\nFirst run yarn db:snapshot to create it.${NO_COLOR}"
  exit 1
fi

docker exec -e PGUSER=postgres $db_container dropdb "${app}_development" --if-exists
docker exec -e PGUSER=postgres $db_container createdb -T "${app}_development_snapshot" "${app}_development"

echo -e "${GREEN}We've restored ${app}_development from ${app}_development_snapshot.${NO_COLOR}"
