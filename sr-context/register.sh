#!/bin/sh

set -e
cd "$(dirname -- "$0")"

if [ $# -lt 3 ]; then
  echo "usage: $0 sr subject schema"
  exit
fi

url=$1
shift

subject=$1
shift

schema=$1
shift

declare -a schemas

SCHEMA=$(jq '. | tojson' $schema)

DATA=$(cat <<EOF
{
  "schema" : ${SCHEMA},
  "schemaType" : "AVRO"
}
EOF)

echo ${subject}
curl -s -X POST -H "Content-Type:application/json" --data "${DATA}" "${url}/subjects/${subject}/versions/" | jq
echo ""

