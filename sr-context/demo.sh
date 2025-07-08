#!/bin/sh

if ! [ -x "$(command -v jq)" ]; then
    echo "\njq is not found, please install and make it available on your path, https://stedolan.github.io/jq\n"
    exit 1
fi

set -e
cd "$(dirname -- "$0")"

echo ""
echo "step 0: start the cluster"
echo ""

docker compose up -d --wait

echo ""
echo "step 1: create a link from src1 schema registry to dst schema registry"
echo ""

./create-src1-to-dst-link.sh

echo ""
echo "step 2: create a link from src2 schema registry to dst schema registry"
echo ""

./create-src2-to-dst-link.sh

echo ""
echo "*****"
echo "notice how both links are named LINK, since link names are tied to source cluster only."
echo "*****"
echo ""

echo ""
echo "step 3: create schema in src1 schema-registry customer v1, customer v2, store v1"
echo ""

./register.sh http://localhost:8081 customer-value ./avro/customer_v1.avsc
./register.sh http://localhost:8081 customer-value ./avro/customer_v2.avsc
./register.sh http://localhost:8081 store-value ./avro/store_v1.avsc

echo ""
echo "step 4: create schema in src2 schema-registry store v1, customer v1, customer v2"
echo ""

./register.sh http://localhost:8082 store-value ./avro/store_v1.avsc
./register.sh http://localhost:8082 customer-value ./avro/customer_v1.avsc
./register.sh http://localhost:8082 customer-value ./avro/customer_v2.avsc

echo ""
echo ""
echo "step 5: verify schema in src1"
echo ""

../bin/confluent-7.7.1/bin/kafka-console-consumer --bootstrap-server http://localhost:9092 \
  --property print.key=true \
  --property key.separator=\| \
  --topic _schemas_src1 \
  --from-beginning \
  --timeout-ms 2000

echo ""
echo ""
echo "step 6: verify schema in src2"
echo ""

../bin/confluent-7.7.1/bin/kafka-console-consumer --bootstrap-server http://localhost:9092 \
  --property print.key=true \
  --property key.separator=\| \
  --topic _schemas_src2 \
  --from-beginning \
  --timeout-ms 2000

echo ""
echo ""
echo "step 7: verify schema dest schema-registry (reminder :X: -> X is a context name)"
echo ""

../bin/confluent-7.7.1/bin/kafka-console-consumer --bootstrap-server http://localhost:9092 \
  --property print.key=true \
  --property key.separator=\| \
  --topic _schemas_dst \
  --from-beginning \
  --timeout-ms 2000

echo ""
echo ""
echo "step 8: finding schema on destination by id and subject"
echo ""

./verify.sh