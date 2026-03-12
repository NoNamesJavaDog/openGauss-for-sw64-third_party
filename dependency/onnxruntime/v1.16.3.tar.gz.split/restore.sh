#!/bin/bash
# 还原 v1.16.3.tar.gz
cd "$(dirname "$0")"
cat part_* > "../v1.16.3.tar.gz"
echo "已还原: v1.16.3.tar.gz"
