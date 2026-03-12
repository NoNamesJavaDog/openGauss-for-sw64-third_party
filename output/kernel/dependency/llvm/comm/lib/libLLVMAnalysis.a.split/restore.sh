#!/bin/bash
# 还原 libLLVMAnalysis.a
cd "$(dirname "$0")"
cat part_* > "../libLLVMAnalysis.a"
echo "已还原: libLLVMAnalysis.a"
