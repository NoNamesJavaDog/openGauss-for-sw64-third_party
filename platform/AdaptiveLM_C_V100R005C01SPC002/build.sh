#!/bin/bash
#######################################################################
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
# description: the script that make install asn1crypto
# version: 1.2.0
# date: 
# history:
#######################################################################
set -e
PLATFORM=$(sh $(pwd)/../../build/get_PlatForm_str.sh)
mkdir -p $(pwd)/../../output/platform/$PLATFORM/AdaptiveLM_C_V100R005C01SPC002
export TARGET=$(pwd)/../../output/platform/$PLATFORM/AdaptiveLM_C_V100R005C01SPC002
ls ./ |grep -v .sh |xargs -i cp -r ./{} $TARGET
