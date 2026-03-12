#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2010-2018. All rights reserved.
# description: the script that make install xgboost
# date:
# modified:
# version: 1.0.2
# history:

set -e

PKG_FILE=v1.7.3.zip

export TARGET_PATH=$(pwd)/../../output/kernel/dependency/
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH

export SOURCE_FILE=xgboost-1.7.3

if [ -d ${SOURCE_FILE} ]; then
    rm -rf ${SOURCE_FILE}
fi
mkdir ${SOURCE_FILE}

unzip ${PKG_FILE}

export DMLC_FILE=dmlc-core
cd $SOURCE_FILE

sed -i '9a set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wl,-z,now -fPIE -fPIC  -fstack-protector-strong -D_FORTIFY_SOURCE=2 -O2")' ./CMakeLists.txt
sed -i '10a set (CMAKE_CPP_FLAGS "${CMAKE_CPP_FLAGS} -Wl,-z,now -fPIE -fPIC -fstack-protector-strong -D_FORTIFY_SOURCE=2 -O2")' ./CMakeLists.txt
sed -i '11a set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,-z,now -fPIE -fPIC -fstack-protector-strong -D_FORTIFY_SOURCE=2 -O2")' ./CMakeLists.txt

rm -rf dmlc-core
cp -r ../../$DMLC_FILE/$DMLC_FILE ./dmlc-core

rm -rf build_install
mkdir build_install && cd build_install
cmake .. -DCMAKE_INSTALL_PREFIX=$(pwd)/install_comm
make -j4
make install

rm -rf install_comm/bin install_comm/lib
export INSTALL_DIR=${TARGET_PATH}/xgboost
mkdir -p ${INSTALL_DIR}/comm ${INSTALL_DIR}/llt
cp -r install_comm/* ${INSTALL_DIR}/comm
cp -r install_comm/* ${INSTALL_DIR}/llt
