#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
set -e
mkdir -p $(pwd)/../../output/install_tools
export TARGET_PATH=$(pwd)/../../output/install_tools/
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH
export PYTHONPATH=$TARGET_PATH:$PYTHONPATH
TAR_SOURCE_FILE=pycparser-release_v2.21.tar.gz
SOURCE_FILE=pycparser
if [ -d ${SOURCE_FILE} ]; then
    rm -rf ${SOURCE_FILE}
fi
mkdir ${SOURCE_FILE}
tar -zxf $TAR_SOURCE_FILE -C $SOURCE_FILE --strip-components 1 
cd $SOURCE_FILE
python3 setup.py build
PYTHONHASHSEED=0 python3 setup.py install --user
preloader_dir_path=$(pip3 show pycparser | awk '/Location/{ print $2 }')
\cp -r ${preloader_dir_path}/pycparser $TARGET_PATH/
