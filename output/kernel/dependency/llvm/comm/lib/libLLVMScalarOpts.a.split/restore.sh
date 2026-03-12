#!/bin/bash
# 还原 libLLVMScalarOpts.a
cd "$(dirname "$0")"
cat part_* > "../libLLVMScalarOpts.a"
echo "已还原: libLLVMScalarOpts.a"
