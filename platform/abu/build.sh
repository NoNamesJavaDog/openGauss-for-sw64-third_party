#!/bin/bash
#######################################################################
# Copyright (c): 2012-2022, Huawei Tech. Co., Ltd.
# description: the script that make install abu
# version: 
# date: 
# history:
#######################################################################
set -e
PLATFORM=$(sh $(pwd)/../../build/get_PlatForm_str.sh)
mkdir -p $(pwd)/../../output/platform/$PLATFORM/libabu
export TARGET=$(pwd)/../../output/platform/$PLATFORM/libabu
ls ./ |grep -v .sh |xargs -i cp -r ./{} $TARGET