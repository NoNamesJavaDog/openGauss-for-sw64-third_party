#!/bin/bash
#  Copyright (c) Huawei Technologies Co., Ltd. 2010-2023. All rights reserved.
#  description: the script that make install masstree
#  date: 2020-12-16
#  version: 1.0
#  history:
#    2020-12-16 first version
#    2023-08-29 change Masstree base version to v1.0.1 and squash all changes into single patch file

set -e
# change compress type

CUR_DIR=$(pwd)

MASSTREE_PACKAGE=masstree-beta-1.0.1.tar.gz
MASSTREE_SOURCES_TMP_DIR=tmp
LOCAL_DIR=$(dirname "${LOCAL_PATH}")
MASSTREE_MEGRED_SOURCES_DIR=masstree-beta

if [ -d ${MASSTREE_MEGRED_SOURCES_DIR} ]; then
    rm -rf ${MASSTREE_MEGRED_SOURCES_DIR}
fi
mkdir ${MASSTREE_MEGRED_SOURCES_DIR}
tar -zxf $MASSTREE_PACKAGE -C $MASSTREE_MEGRED_SOURCES_DIR --strip-components 1

cd $MASSTREE_MEGRED_SOURCES_DIR
patch -p1 < ../0001-Masstree-v1.0.1-MOT.patch
sed -i "s/LDFLAGS =/LDFLAGS = -fstack-protector-all -z,now/g" Makefile
if [ "$(uname -m)" = "sw_64" ]; then
    sed -i "s/CXXFLAGS += -mcx16/# sw_64: -mcx16 not supported/g" Makefile
    sed -i "s/-Wcast-align/-Wno-cast-align/g" Makefile
fi
sed -i "s/\$(CXX) -shared/\$(CXX) -fstack-protector-all -Wl,-z,relro,-z,now -shared/g" Makefile

make -sj
rm -rf *.o
cd ..

LOCAL_DIR=$(dirname "${LOCAL_PATH}")
INSTALL_DIR=${LOCAL_DIR}/../../output/kernel/dependency/masstree
mkdir -p ${INSTALL_DIR}/comm/include
mkdir -p ${INSTALL_DIR}/comm/lib
cp ${MASSTREE_MEGRED_SOURCES_DIR}/*.h* ${INSTALL_DIR}/comm/include
cp ${MASSTREE_MEGRED_SOURCES_DIR}/libmasstree.so ${INSTALL_DIR}/comm/lib
rm -rf ${MASSTREE_MEGRED_SOURCES_DIR}
