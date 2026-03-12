#!/bin/bash
# 还原 llvm-project-llvmorg-12.0.1.tar.gz
cd "$(dirname "$0")"
cat part_* > "../llvm-project-llvmorg-12.0.1.tar.gz"
echo "已还原: llvm-project-llvmorg-12.0.1.tar.gz"
