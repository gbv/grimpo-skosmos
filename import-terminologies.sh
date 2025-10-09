#!/usr/bin/bash
set -euo pipefail

TERMINOLOGIES=$1

importer=http://localhost:5020/
DATA=${DATA:-data}
STAGE=${STAGE:-stage}
DEFAULT="./dockerfiles/config/config-docker-compose-default.ttl"
CONFIG="./dockerfiles/config/config-docker-compose.ttl"

POST() { curl --silent --fail -X POST "$@"; }
PUT() { curl --silent --fail -X PUT "$@"; }

echo "## Register terminologies"
PUT -d @$TERMINOLOGIES ${importer}terminology/ | jq -r '.[]|[.uri,.prefLabel.en]|@tsv'
echo

# reset config
cp $DEFAULT $CONFIG

jq -r '.[]|[.uri,.distributions[0].download]|@tsv' $TERMINOLOGIES | while read -r uri download; do
    id=${uri##*/}
    echo
    echo "## Receive and load $uri"
    POST ${importer}terminology/${id}/receive?from=${download}
    POST ${importer}terminology/${id}/load
    cat $STAGE/terminology/${id}/skosmos.ttl >> $CONFIG    
done