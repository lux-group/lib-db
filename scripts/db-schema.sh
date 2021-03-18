#!/bin/bash
set -e

app=${1:-$APP_NAME}
environment=${APP_ENV:-development}
repoDirectory=${REPO_DIRECTORY:-repo}
dev_pg_port=${PGPORT:-"5432"}
pg_options="--port=$dev_pg_port"

NO_COLOR='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

if [ -z "$app" ]
  then
    echo -e "${RED}No app_name provided${NO_COLOR}"
    echo "Usage: lib-db schema app_name"
    exit 1
fi

if [ -z "$DB" ]
  then
    DB="${app}_${environment}"
fi

pg_dump $pg_options \
  --schema-only \
  --no-owner \
  $DB > ${repoDirectory}/schema.sql
