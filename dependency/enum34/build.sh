#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
set -e
mkdir -p $(pwd)/../../output/install_tools
export TARGET_PATH=$(pwd)/../../output/install_tools
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH
TAR_SOURCE_FILE=enum34-1.1.9.tar.gz
SOURCE_FILE=enum34-1.1.9
tar zxvf $TAR_SOURCE_FILE
cd $SOURCE_FILE
python setup.py build
python setup.py install --user
cp -r build/lib*/* $TARGET_PATH
