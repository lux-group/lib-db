#! /bin/bash
set -e

app=${1:-$APP_NAME}
environment=${APP_ENV:-development}
dev_pg_port=${PGPORT:-"5432"}
pg_options="--port=$dev_pg_port"

NO_COLOR='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

if [ -z "$app" ]
  then
    echo -e "${RED}No app_name provided${NO_COLOR}"
    echo "Usage: lib-db create app_name"
    exit 1
fi

if [ -z "$DB" ]
  then
    DB="${app}_${environment}"
fi
cmd="CREATE DATABASE $DB"

echo "$cmd"

if [ ! -z "$DATABASE_URL" ]; then
    psql "$DATABASE_URL" -c "$cmd"
else
  if [ -z "$HOST" ]
    then
      HOST="127.0.0.1"
  fi

  psql $pg_options -h ${HOST} -c "$cmd"
fi

