#!/bin/bash
# 还原 aws-sdk-cpp-1.11.712.tar.gz
cd "$(dirname "$0")"
cat part_* > "../aws-sdk-cpp-1.11.712.tar.gz"
echo "已还原: aws-sdk-cpp-1.11.712.tar.gz"
