#!/bin/bash
#######################################################################
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
# description: the script that make install netifaces
# version: 1.10.9
# date:
# history:
#######################################################################
set -e
python $(pwd)/../../build/pull_open_source.py "netifaces" "netifaces-release_0_10_9.tar.gz" "05833LEF"
PLATFORM=$(sh $(pwd)/../../build/get_PlatForm_str.sh)
mkdir -p $(pwd)/../../output/dependency/install_tools_$PLATFORM
python_version=`python -V | awk -F ' ' '{print $2}' |awk -F '.' -v OFS='.' '{print $1,$2}'`
file_name=${python_version/./}m
export TARGET_PATH=$(pwd)/../../output/dependency/install_tools_$PLATFORM
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH
TAR_SOURCE_FILE=netifaces-release_0_10_9.tar.gz
SOURCE_FILE=netifaces-release_0_10_9
mkdir -p $TARGET_PATH/netifaces

# build netifaces.so_UCS2 using buildtools/python
cd ../
rm -rf $SOURCE_FILE
tar zxvf $TAR_SOURCE_FILE
cd $SOURCE_FILE
PYTHON_PATH=$(pwd)/../../../buildtools/python
${PYTHON_PATH}/ucs2/build/bin/python setup.py build
if [[ "$PLATFORM" == centos* ]]; then
    CPU_BIT=$(uname -m)
    if [ X"$CPU_BIT" = X"x86_64" ]; then
        gcc -pthread -shared -Wl,-z,relro,-z,now,-z,noexecstack -s -ftrapv -g build/temp.linux-x86_64-$python_version/netifaces.o -o build/lib.linux-x86_64-$python_version/netifaces.cpython-$file_name-x86_64-linux-gnu.so
    fi
fi
${PYTHON_PATH}/ucs2/build/bin/python setup.py install
cp -r build/lib*/netifaces.so $TARGET_PATH/netifaces/netifaces.so_UCS2
