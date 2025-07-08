#!/bin/sh

set -e
cd "$(dirname -- "$0")"

../bin/confluent-7.7.1/bin/schema-exporter --create \
	--name LINK \
	--config-file ./sr-dst.properties \
	--schema.registry.url http://localhost:8082/ \
	--context-type CUSTOM \
	--context-name SRC2

