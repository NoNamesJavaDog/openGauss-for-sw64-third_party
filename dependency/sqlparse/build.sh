#!/bin/bash
# Copyright (c): 2021-2025, Huawei Tech. Co., Ltd.
set -e
mkdir -p $(pwd)/../../output/install_tools
export TARGET_PATH=$(pwd)/../../output/install_tools/
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH
PACKAGE_FILE=0.4.3.tar.gz
SOURCE_FILE=sqlparse-0.4.3

if [ -d ${SOURCE_FILE} ]; then
    rm -rf ${SOURCE_FILE}
fi
mkdir ${SOURCE_FILE}
tar -zxf ${PACKAGE_FILE} -C ${SOURCE_FILE} --strip-components 1
cd $SOURCE_FILE
python3 setup.py build
cp -r build/lib*/* $TARGET_PATH
