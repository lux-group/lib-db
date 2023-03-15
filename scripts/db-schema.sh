#!/bin/bash
set -e
set -o errexit   # abort on nonzero exitstatus
set -o pipefail  # don't hide errors within pipes

app=${1:-$APP_NAME}
db_container=${2:-$DB_CONTAINER}
environment=${APP_ENV:-development}
repo_directory=${REPO_DIRECTORY:-repo}
export_location=${repo_directory}/schema.sql

NO_COLOR='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

if [ -z "$app" ]
  then
    echo -e "${RED}No app_name provided${NO_COLOR}"
    echo "Usage: lib-db schema app_name db_container"
    exit 1
fi

if [ -z "$db_container" ]
  then
    echo -e "${RED}Missing DB_CONTAINER env variable${NO_COLOR}"
    echo "Usage: lib-db schema app_name db_container"
    exit 1
fi

if [ -z "$DB" ]
  then
    DB="${app}_${environment}"
fi

docker exec -e PGUSER=postgres $db_container pg_dump "${app}_development" --schema-only --no-owner > $export_location

echo -e "${GREEN}We've exported the db schema of ${app}_development to $export_location"