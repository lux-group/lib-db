#! /bin/bash
set -e

app=${1:-$APP_NAME}
db_container=${3:-$DB_CONTAINER}
environment=${APP_ENV:-development}

NO_COLOR='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

if [ -z "$app" ]
  then
    echo -e "${RED}No app_name provided${NO_COLOR}"
    echo "Usage: lib-db drop app_name"
    exit 1
fi

if [ -z "$DB" ]
  then
    DB="${app}_${environment}"
fi

echo "docker exec -e PGUSER=postgres $db_container dropdb $DB --if-exists"
docker exec -e PGUSER=postgres $db_container dropdb $DB --if-exists
