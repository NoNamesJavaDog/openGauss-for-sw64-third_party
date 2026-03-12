#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
set -e

# download kmc source
SOURCE_FILE=KMC

# config TARGET_PATH
PLATFORM=$(sh $(pwd)/../../build/get_PlatForm_str.sh)
mkdir -p $(pwd)/../../output/platform/$PLATFORM/kmc/comm
export TARGET_PATH=$(pwd)/../../output/platform/$PLATFORM/kmc/comm
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH

# config KMC_LD_PATH
export KMC_LD_PLATFORM_PATH=$TARGET_PATH/../..
export KMC_LD_DEPEND_PATH=$KMC_LD_PLATFORM_PATH/../../dependency/$PLATFORM

# copy makefile and patch
cp -f fix_keyring.patch $SOURCE_FILE
cp -f Makefile $SOURCE_FILE

# patch && make
cd $SOURCE_FILE
patch -p1 < fix_keyring.patch
mkdir -p lib
make -sj

# copy lib and include
cp -rf lib $TARGET_PATH
cp -rf include $TARGET_PATH

