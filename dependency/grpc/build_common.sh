#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
# description: the script that make install grpc
# date: 2020-11-25
# version: 1.0
# history:
# 2020-11-25 first commit

########################################################################
# Environment setting
########################################################################
set -e
python $(pwd)/../../build/pull_open_source.py "grpc" "grpc-1.28.1.tar.gz" "05834MFX"

LOCAL_PATH=${0}
FIRST_CHAR=$(expr substr "$LOCAL_PATH" 1 1)
if [ "$FIRST_CHAR" = "/" ]; then
    LOCAL_PATH=${0}
else
    LOCAL_PATH="$(pwd)/${LOCAL_PATH}"
fi
LOCAL_DIR=$(dirname "${LOCAL_PATH}")
TO_3RD=$LOCAL_DIR/build
export PATH=$(pwd)/../../output/dependency/euleros2.0_sp5_x86_64/protobuf/comm/bin:$PATH
MAIN=$LOCAL_DIR/../..
platform=$(sh ../../build/get_PlatForm_str.sh)
OPENSSL_ROOT=$LOCAL_DIR/../openssl/install/comm
PROTOBUF_ROOT=$LOCAL_DIR/../protobuf/install_comm
rm -rf grpc-1.28.1 pkgconfig
mkdir pkgconfig
rm -rf install
mkdir install
rm -rf build
mkdir build
cd build
mkdir lib
mkdir include
cd ..
export PATH=$PROTOBUF_ROOT/bin:$PATH
export LD_LIBRARY_PATH=$CARES_ROOT/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$LOCAL_DIR/pkgconfig
tar zxvf grpc-1.28.1.tar.gz
cd grpc-1.28.1
patch -p1 < ../huawei_grpc-1.28.1.patch
patch -p1 < ../huawei_grpc_add-1.28.1.patch
patch -p1 < ../huawei_grpc_another-1.28.1.patch
CUR_SRC=`pwd`
rm -fr t_build
mkdir t_build
cd t_build
cp -fr ${LOCAL_DIR}/../abseil-cpp/abseil-cpp-20200225/* ../third_party/abseil-cpp/
cp -r ${LOCAL_DIR}/../protobuf/install_comm/lib/* ../../build/lib/
cp -r ${LOCAL_DIR}/../protobuf/install_comm/include/* ../../build/include/
cp -r ${LOCAL_DIR}/../c-ares/install_comm/lib/* ../../build/lib/
cp -r ${LOCAL_DIR}/../c-ares/install_comm/include/* ../../build/include/
cp -r ${LOCAL_DIR}/../openssl/install/comm/lib/* ../../build/lib/
cp -r ${LOCAL_DIR}/../openssl/install/comm/include/* ../../build/include/
cp -r ${MAIN}/output/dependency/$platform/zlib1.2.11/comm/lib/* ../../build/lib/
cp -r ${MAIN}/output/dependency/$platform/zlib1.2.11/comm/include/* ../../build/include/
