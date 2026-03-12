#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
set -e
mkdir -p $(pwd)/../../output/install_tools
export TARGET_PATH=$(pwd)/../../output/install_tools/
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH
export PYTHONPATH=$TARGET_PATH:$PYTHONPATH
TAR_SOURCE_FILE=ipaddress-1.0.22.tar.gz
SOURCE_FILE=ipaddress-1.0.22
tar zxvf $TAR_SOURCE_FILE
cd $SOURCE_FILE
patch -p1 < ../ipaddress-1.0.patch
python3 setup.py build
python3 setup.py install --user
cp -r build/lib*/* $TARGET_PATH
