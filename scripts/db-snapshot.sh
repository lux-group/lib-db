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
    echo "Usage: lib-db snapshot app_name"
    exit 1
fi

dropdb --if-exists $pgoptions "${app}_development_snapshot" 
createdb -T --host $pgoptions "${app}_development" "${app}_development_snapshot"

echo -e "${GREEN}We've made a copy of ${app}_development at ${app}_development_snapshot.
You can restore it with yarn db:snapshot:restore${NO_COLOR}"

exit 0

