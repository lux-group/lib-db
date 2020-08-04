#! /bin/bash
set -e

app=${1:-$APP_NAME}
devpghost=${2:-${PGHOST:-"localhost"}}
devpgport=${3:-${PGPORT:-"5432"}}
pgoptions="--host $devpghost --port $devpgport"

NO_COLOR='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

if [ -z "$app" ]
  then
    echo -e "${RED}No app_name provided${NO_COLOR}"
    echo "Usage: lib-db snapshot-restore app_name"
    exit 1
fi

# check if DB exists - from https://stackoverflow.com/a/17757560/1373987
if [ "$( psql -tAc "SELECT 1 FROM pg_database WHERE datname='${app}_development_snapshot'" )" != '1' ]
then
  echo -e "${RED}${app}_development_snapshot does not exist.\nFirst run yarn db:snapshot to create it.${NO_COLOR}"
  exit 1
fi

dropdb --if-exists "${app}_development" 
createdb -T "${app}_development_snapshot" "${app}_development"

echo -e "${GREEN}We've restored ${app}_development from ${app}_development_snapshot.${NO_COLOR}"

exit 0

