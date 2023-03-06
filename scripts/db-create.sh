#! /bin/bash
set -e
set -o errexit   # abort on nonzero exitstatus
set -o pipefail  # don't hide errors within pipes

app=${1:-$APP_NAME}
db_container=${3:-$DB_CONTAINER}
environment=${APP_ENV:-development}

NO_COLOR='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

if [ -z "$app" ]
  then
    echo -e "${RED}No app_name provided${NO_COLOR}"
    echo "Usage: lib-db create app_name"
    exit 1
fi

if [ -z "$db_container" ]
  then
    echo -e "${RED}Missing DB_CONTAINER env variable${NO_COLOR}"
    exit 1
    fi
fi

if [ -z "$DB" ]
  then
    DB="${app}_${environment}"
fi

echo "docker exec -e PGUSER=postgres $db_container createdb $DB"
docker exec -e PGUSER=postgres $db_container createdb $DB