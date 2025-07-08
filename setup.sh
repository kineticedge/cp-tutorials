#!/bin/bash

set -e
cd "$(dirname -- "$0")/bin"

if [ ! -f "./confluent-7.7.1.tar.gz" ]; then
    echo "downloading confluent platform distro"
    curl -s -O https://packages.confluent.io/archive/7.7/confluent-7.7.1.tar.gz
fi

if [ ! -d "./confluent-7.7.1" ]; then
    echo "untarring confluent platform distro"
    tar xfv ./confluent-7.7.1.tar.gz
fi
