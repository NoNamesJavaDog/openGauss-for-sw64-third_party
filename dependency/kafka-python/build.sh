#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
set -e
python $(pwd)/../../build/pull_open_source.py "kafka-python" "kafka-python-2.0.0.tar.gz" "05835PPS"
PLATFORM=$(sh $(pwd)/../../build/get_PlatForm_str.sh)
mkdir -p $(pwd)/../../output/dependency/install_tools_$PLATFORM
export TARGET_PATH=$(pwd)/../../output/dependency/install_tools_$PLATFORM/kafka-python
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH
TAR_SOURCE_FILE=kafka-python-2.0.0.tar.gz
SOURCE_FILE=kafka-python-2.0.0
test ./kafka-python-2.0.0 && rm -rf ./kafka-python-2.0.0
tar -zxf $TAR_SOURCE_FILE
cd $SOURCE_FILE
python setup.py build
python setup.py install --user
cp -r build/lib*/* $TARGET_PATH
