#!/bin/bash
#######################################################################
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
# description: the script that make install bottle
# version: 0.12.17
# date:
# history:
#######################################################################
set -e
mkdir -p $(pwd)/../../output/install_tools
export TARGET_PATH=$(pwd)/../../output/install_tools/bottle
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH
TAR_SOURCE_FILE=0.12.25.tar.gz
SOURCE_FILE=bottle-0.12.25
if [ -d ${SOURCE_FILE} ]; then
    rm -rf ${SOURCE_FILE}
fi
mkdir ${SOURCE_FILE}
tar -zxf $TAR_SOURCE_FILE -C $SOURCE_FILE --strip-components 1
cd $SOURCE_FILE
python3 setup.py build
sed -i "s/scripts=/#scripts=/g" setup.py
python3 setup.py install --user
mkdir -p $TARGET_PATH
cp -r build/lib*/* $TARGET_PATH
touch $TARGET_PATH/__init__.py
