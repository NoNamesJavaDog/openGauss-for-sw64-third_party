#!/bin/bash
# *************************************************************************
# Copyright: (c) Huawei Technologies Co., Ltd. 2019. All rights reserved
set -e
mkdir -p $(pwd)/../python-lib
mkdir -p $(pwd)/../../output/install_tools
export TARGET_PATH=$(pwd)/../../output/install_tools/
TAR_SOURCE_FILE=3.4.0.tar.gz
SOURCE_FILE=paramiko-3.4.0
if [ -d ${SOURCE_FILE} ]; then
    rm -rf ${SOURCE_FILE}
fi
mkdir ${SOURCE_FILE}
tar -zxf $TAR_SOURCE_FILE -C $SOURCE_FILE --strip-components 1
cd $SOURCE_FILE
python3 setup.py build
python3 setup.py install --user
cp -r build/lib*/* $TARGET_PATH
