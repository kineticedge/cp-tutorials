#!/bin/sh

set -e
cd "$(dirname -- "$0")"

echo ""
echo "---"
echo ""
echo "ID=1 Subject=customer-value"
echo "\n:SRC1:"
curl -s http://localhost:8083/contexts/:SRC1:/schemas/ids/1\?subject=customer-value | jq

echo "\n:SRC2:"
curl -s http://localhost:8083/contexts/:SRC2:/schemas/ids/1\?subject=customer-value | jq

echo "\n:.:"
curl -s http://localhost:8083/contexts/:.:/schemas/ids/1\?subject=customer-value | jq

echo ""
echo "---"
echo ""
echo "ID=1 Subject=store-value"
echo "\n:SRC1:"
curl -s http://localhost:8083/contexts/:SRC1:/schemas/ids/1\?subject=store-value | jq

echo "\n:SRC2:"
curl -s http://localhost:8083/contexts/:SRC2:/schemas/ids/1\?subject=store-value | jq

echo "\n:.:"
curl -s http://localhost:8083/contexts/:.:/schemas/ids/1\?subject=store-value | jq

echo ""
echo "---"
echo ""
echo "ID=2 Subject=customer-value **BOTH CONTEXTS HAVE id=2 FOR A customer-value, BUT VERSIONS ARE DIFFERENT**"
echo "\n:SRC1:"
curl -s http://localhost:8083/contexts/:SRC1:/schemas/ids/2\?subject=customer-value | jq
echo "\n:SRC2:"
curl -s http://localhost:8083/contexts/:SRC2:/schemas/ids/2\?subject=customer-value | jq
echo "\n:.:"
curl -s http://localhost:8083/contexts/:.:/schemas/ids/2\?subject=customer-value | jq
