#!/bin/bash
#######################################################################
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
# description: the script that make install netifaces
# version: 1.10.9
# date:
# history:
#######################################################################
set -e

mkdir -p $(pwd)/../../output/install_tools
python_version=`python3 -V | awk -F ' ' '{print $2}' |awk -F '.' -v OFS='.' '{print $1,$2}'`
file_name=${python_version/./}m
export TARGET_PATH=$(pwd)/../../output/install_tools/
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH

mkdir -p $TARGET_PATH/netifaces
TAR_SOURCE_FILE=netifaces-release_0_11_0.tar.gz
SOURCE_FILE=netifaces
if [ -d ${SOURCE_FILE} ]; then
    rm -rf ${SOURCE_FILE}
fi
mkdir ${SOURCE_FILE}
tar -zxf $TAR_SOURCE_FILE -C $SOURCE_FILE --strip-components 1

cd $SOURCE_FILE
CFLAGS='-fstack-protector-all' LDFLAGS='-Wl,-z,relro,-z,now -z,noexecstack' python3 setup.py build
if [[ "$PLATFORM" == centos* ]]; then
    CPU_BIT=$(uname -m)
    if [ X"$CPU_BIT" = X"x86_64" ]; then
        gcc -pthread -shared -Wl,-z,relro,-z,now,-z,noexecstack -s -ftrapv -g build/temp.linux-x86_64-$python_version/netifaces.o -o build/lib.linux-x86_64-$python_version/netifaces.cpython-$file_name-x86_64-linux-gnu.so
    fi
fi
python3 setup.py install --user
cp -r build/lib*/* $TARGET_PATH/netifaces
cd build/lib*/
mv netifaces.*.so netifaces.so
cd ../../
cp -r build/lib*/netifaces.so $TARGET_PATH/netifaces/netifaces.so_UCS4
cp -r build/lib*/netifaces.so $TARGET_PATH/netifaces/netifaces.so

cp ./../netifaces.py $TARGET_PATH/netifaces/netifaces.py
