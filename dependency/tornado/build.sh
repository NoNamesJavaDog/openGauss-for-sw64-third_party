#!/bin/bash
# Copyright (c): 2020-2025, Huawei Tech. Co., Ltd.
set -e
mkdir -p $(pwd)/../../output/install_tools
export TARGET_PATH=$(pwd)/../../output/install_tools/
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH
TAR_SOURCE_FILE=tornado-6.3.2.tar.gz
SOURCE_FILE=tornado-6.3.2
if [ -d ${SOURCE_FILE} ]; then
    rm -rf ${SOURCE_FILE}
fi
mkdir -p ${SOURCE_FILE}
tar -zxf $TAR_SOURCE_FILE -C $SOURCE_FILE --strip-components 1
cd $SOURCE_FILE
patch -p1 < ../CVE-2025-47287.patch
patch -p1 < ../CVE-2025-67724.patch
patch -p1 < ../CVE-2025-67726.patch
python3 setup.py build
python3 setup.py install --user
cp -r build/lib*/* $TARGET_PATH
