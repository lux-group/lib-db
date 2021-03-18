#!/bin/bash
set -e

migrationName=$1
repoDirectory=${REPO_DIRECTORY:-repo}
app=${2:-$APP_NAME}

NO_COLOR='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

if [ -z "$migrationName" ]
  then
    echo -e "${RED}No migration_name provided${NO_COLOR}"
    echo "Usage: lib-db migrate-create migration_name app_name"
    exit 1
fi

if [ -z "$app" ]
  then
    echo -e "${RED}No app_name provided${NO_COLOR}"
    echo "Usage: lib-db migrate-create migration_name app_name"
    exit 1
fi


TS=$(date "+%s")

touch $repoDirectory/migrations/$TS.do.$migrationName.sql
echo "created $repoDirectory/migrations/$TS.do.$migrationName.sql"
