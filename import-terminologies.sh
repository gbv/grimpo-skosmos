#!/usr/bin/bash
set -euo pipefail

importer=http://localhost:5020/
DATA=${DATA:-data}
STAGE=${STAGE:-stage}
DEFAULT="./dockerfiles/config/skosmos-default.ttl"
CONFIG="./dockerfiles/config/skosmos.ttl"

POST() { curl --silent --fail -X POST "$@"; }
PUT() { curl --silent --fail -X PUT "$@"; }
GET() { curl --silent --fail "$@"; }
import() {
    echo "## Register terminologies"
    PUT -d @$@ ${importer}terminology/ | jq -r '.[]|[.uri,.prefLabel.en]|@tsv'
    echo

    jq -r '.[]|[.uri,.distributions[0].download]|@tsv' $@ | while read -r uri download; do
        id=${uri##*/}
        echo
        echo "## Receive and load $uri"
        POST ${importer}terminology/${id}/receive?from=${download}
        POST ${importer}terminology/${id}/load   
    done
}

# reset config
cp $DEFAULT $CONFIG

if [[ $1 =~ ^http://bartoc.org/en/node/.* ]]; then
    uri=$1
    id=${uri##*/}
    download=$2

    echo "## Register terminology"
    PUT ${importer}terminology/${id} | jq -r '[.uri,.prefLabel.en]|@tsv'
    echo
    echo "## Receive and load $uri"
    POST ${importer}terminology/${id}/receive?from=${download}
    POST ${importer}terminology/${id}/load
    
    
else
    TERMINOLOGIES=$1

    import $TERMINOLOGIES
fi

GET ${importer}terminology/skosmos.ttl >> $CONFIG

