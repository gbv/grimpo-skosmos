#!/usr/bin/bash
set -euo pipefail

importer=http://localhost:5020/
apis=http://localhost:8000/
DATA=${DATA:-../data}
STAGE=${STAGE:-../stage}
DEFAULT="./../dockerfiles/config/config-docker-compose-default.ttl"
CONFIG="./../dockerfiles/config/config-docker-compose.ttl"

POST() { curl --silent --fail -X POST "$@"; }
PUT() { curl --silent --fail -X PUT "$@"; }
download() { wget --quiet -N --no-if-modified-since "$@"; } 

echo "## Register terminologies"
PUT -d @terminologies.json ${importer}terminology/ | jq -r '.[]|[.uri,.prefLabel.en]|@tsv'
echo

# reset config
cp $DEFAULT $CONFIG

echo
echo "## Receive and load KENOM Material"
download https://api.dante.gbv.de/export/download/kenom_material/default/kenom_material__default.jskos.ndjson
cp kenom_material__default.jskos.ndjson $DATA
POST ${importer}terminology/20533/receive?from=kenom_material__default.jskos.ndjson
POST ${importer}terminology/20533/load
cat $STAGE/terminology/20533/skosmos.ttl >> $CONFIG

echo
echo "## Receive and load STW Material"
download http://zbw.eu/stw/version/latest/download/stw.ttl.zip
cp stw.ttl.zip $DATA
POST ${importer}terminology/313/receive?from=stw.ttl.zip
POST ${importer}terminology/313/load
cat $STAGE/terminology/313/skosmos.ttl >> $CONFIG