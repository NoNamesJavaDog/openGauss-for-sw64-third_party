#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2010-2018. All rights reserved.
# description: the script that make install nghttp2
# date: 2020-11-16
# version: 1.41.0
# history:
# upgrade from 1.39.2 to 1.41.0

set -e

export OPENSSL_ROOT_DIR=$(pwd)/../../output/kernel/dependency/openssl/comm
PKG_FILE=nghttp2-1.63.0.tar.gz
SOURCE_PATH=nghttp2
if [ -d ${SOURCE_PATH} ]; then
    rm -rf ${SOURCE_PATH}
fi
mkdir $SOURCE_PATH
tar -zxf ${PKG_FILE} -C ${SOURCE_PATH} --strip-components 1

current_dir=$(pwd)
nghttp2_dir=$(pwd)/nghttp2
build_dir=$(pwd)/install_comm

rm -rf install_*
mkdir -p ${build_dir}

cd $nghttp2_dir
cmake -DCMAKE_INSTALL_PREFIX=$build_dir -D CMAKE_PROJECT_INCLUDE=${current_dir}/project_include.cmake -DENABLE_APP=OFF -DENABLE_HPACK_TOOLS=OFF -DENABLE_EXAMPLES=OFF

make install -sj

cd ..
[ -d install_comm/lib64 ] && mv install_comm/lib64 install_comm/lib || true
cp -r install_comm install_llt
