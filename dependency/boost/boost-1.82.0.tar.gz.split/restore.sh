#!/bin/bash
# 还原 boost-1.82.0.tar.gz
cd "$(dirname "$0")"
cat part_* > "../boost-1.82.0.tar.gz"
echo "已还原: boost-1.82.0.tar.gz"
