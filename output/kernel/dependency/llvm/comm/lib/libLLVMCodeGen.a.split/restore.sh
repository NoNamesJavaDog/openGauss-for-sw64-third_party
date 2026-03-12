#!/bin/bash
# 还原 libLLVMCodeGen.a
cd "$(dirname "$0")"
cat part_* > "../libLLVMCodeGen.a"
echo "已还原: libLLVMCodeGen.a"
