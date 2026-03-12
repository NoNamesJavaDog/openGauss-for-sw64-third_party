#!/bin/bash
# *************************************************************************
# Copyright: (c) Huawei Technologies Co., Ltd. 2020. All rights reserved
#
#  description: the script that make install zstd
#  date: 2020-01-16
#  version: 1.0
#  history:
#
# *************************************************************************
set -e
LOCAL_DIR=$(pwd)

TAR_SOURCE_FILE=v1.5.6.tar.gz
export PACKAGE=zstd-1.5.6
[ -n "${PACKAGE}" ] && rm -rf ${PACKAGE} 
mkdir ${PACKAGE}
tar -zxf $TAR_SOURCE_FILE -C $PACKAGE --strip-components 1
cd ${PACKAGE}
cd programs
cd ..
mkdir -p ../install_comm/lib/
cd build/cmake/
mkdir build
cd build

export SECURITY_CFLAGS="-fPIC -fstack-protector-strong -D_FORTIFY_SOURCE=2"
export SECURITY_LDFLAGS="-Wl,-z,relro,-z,now,-z,noexecstack -D_FORTIFY_SOURCE=2"

cmake -DZSTD_BUILD_STATIC=on \
      -DCMAKE_INSTALL_PREFIX=../../../../install_comm \
      -DCMAKE_C_FLAGS="${SECURITY_CFLAGS}" \
      -DCMAKE_EXE_LINKER_FLAGS="${SECURITY_LDFLAGS}" \
      -DCMAKE_SHARED_LINKER_FLAGS="${SECURITY_LDFLAGS}" \
      -DCMAKE_MODULE_LINKER_FLAGS="${SECURITY_LDFLAGS}" \
      ..

make -j4
make install
[ -d ../../../../install_comm/lib64 ] && mv ../../../../install_comm/lib64/libzstd* ../../../../install_comm/lib/ || true

INSTALL_DIR=${LOCAL_DIR}/../../output/kernel/dependency/zstd
# copy lib to destination
mkdir -p ${INSTALL_DIR}/bin
mkdir -p ${INSTALL_DIR}/include
mkdir -p ${INSTALL_DIR}/lib

cp ${LOCAL_DIR}/install_comm/bin/* ${INSTALL_DIR}/bin/
cp ${LOCAL_DIR}/install_comm/include/* ${INSTALL_DIR}/include/
cp -d ${LOCAL_DIR}/install_comm/lib/libzstd.* ${INSTALL_DIR}/lib/

