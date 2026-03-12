#!/bin/bash
#######################################################################
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
# description: the script that make install asn1crypto
# version: 1.3.0
# date: 
# history:
#######################################################################
set -e
mkdir -p $(pwd)/../../output/install_tools
export TARGET_PATH=$(pwd)/../../output/install_tools/
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH

ZIP_SOURCE_FILE=1.5.1.zip
SOURCE_FILE=asn1crypto-1.5.1

if [ -d ${SOURCE_FILE} ]; then
    rm -rf ${SOURCE_FILE}
fi

unzip ${ZIP_SOURCE_FILE}

cd ${SOURCE_FILE}

python3 setup.py build
python3 setup.py install --user
cp -r build/lib*/* ${TARGET_PATH}
