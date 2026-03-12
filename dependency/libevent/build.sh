#!/bin/bash
#  Copyright (c) Huawei Technologies Co., Ltd. 2010-2018. All rights reserved.
#  description: the script that make install libevent
#  date: 2020-06-08
#  version: -1.0
#  history:
#    2020-06-08 100 LOC.

set -e

LOCAL_PATH=${0}
FIRST_CHAR=$(expr substr "$LOCAL_PATH" 1 1)
if [ "$FIRST_CHAR" = "/" ]; then
    LOCAL_PATH=${0}
else
    LOCAL_PATH="$(pwd)/${LOCAL_PATH}"
fi

LOCAL_DIR=$(dirname "${LOCAL_PATH}")
CONFIG_FILE_NAME=config.ini
BUILD_OPTION=release 
TAR_FILE_NAME=libevent-2.1.12-stable.tar.gz
SOURCE_CODE_PATH=libevent-2.1.12-stable
LOG_FILE=${LOCAL_DIR}/build_event.log
ROOT_DIR="${LOCAL_DIR}/../../"
SSL_LIB="${ROOT_DIR}/output/kernel/dependency/openssl/comm/lib"
SSL_INCLUDE="${ROOT_DIR}/output/kernel/dependency/openssl/comm/include"
INSTALL_COMPOENT_PATH_NAME="${ROOT_DIR}/output/kernel/dependency/event"

export OPENSSL_ROOT_DIR=$(pwd)/../../output/kernel/dependency/openssl/comm

log()
{
    echo "[Build libevent] "$(date +%y-%m-%d" "%T)": $@"
    echo "[Build libevent] "$(date +%y-%m-%d" "%T)": $@" >> "$LOG_FILE" 2>&1
}

function build_component()
{
    cd ${LOCAL_DIR}
    if [ -d ${SOURCE_CODE_PATH} ]; then
        rm -rf ${SOURCE_CODE_PATH}
    fi
    mkdir ${SOURCE_CODE_PATH}
    tar -zxf $TAR_FILE_NAME -C $SOURCE_CODE_PATH --strip-components 1

    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
    sh autogen.sh
    chmod +x configure

    if [ $? -ne 0 ]; then
        die "failed to patch file."
    fi
    mkdir -p ${LOCAL_DIR}/${SOURCE_CODE_PATH}/build_comm
    mkdir -p ${LOCAL_DIR}/install_comm
    log "[Notice] event configure string: ./configure CFLAGS='-O2 -g3' --enable-static=yes --enable-shared=no --with-pic=false CFLAGS='-fPIE' --prefix=${LOCAL_DIR}/install_comm"
    #./configure CFLAGS='-O2 -g3' --enable-static=yes --enable-shared=no --with-pic=false CFLAGS='-fPIE' CPPFLAGS=-I${SSL_INCLUDE} LDFLAGS=-L${SSL_LIB} --prefix=${LOCAL_DIR}/install_comm
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}/build_comm
    cmake .. -DCMAKE_INSTALL_PREFIX=${LOCAL_DIR}/install_comm -D__FLAGS="-fPIE -O2 -g3 -I${SSL_INCLUDE} -L${SSL_LIB}"  -DCMAKE_PROJECT_INCLUDE=${LOCAL_DIR}/project_include.cmake
    make -j4
    make install
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
    rm -rf build_comm

    mkdir -p ${LOCAL_DIR}/${SOURCE_CODE_PATH}/build_llt
    mkdir -p ${LOCAL_DIR}/install_llt
    log "[Notice] event configure string: ./configure CFLAGS='-O2 -g3' --enable-static=yes --enable-shared=no --with-pic=false CFLAGS='-fPIE' --prefix=${LOCAL_DIR}/install_llt"
    #./configure CFLAGS='-O2 -g3' --enable-static=yes --enable-shared=no --with-pic=false CFLAGS='-fPIE' CPPFLAGS=-I${SSL_INCLUDE} LDFLAGS=-L${SSL_LIB} --prefix=${LOCAL_DIR}/install_llt
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}/build_llt
    cmake .. -DCMAKE_INSTALL_PREFIX=${LOCAL_DIR}/install_llt -D__FLAGS="-fPIE -O2 -g3 -I${SSL_INCLUDE} -L${SSL_LIB}"  -DCMAKE_PROJECT_INCLUDE=${LOCAL_DIR}/project_include.cmake
    make -j4
    make install
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
    rm -rf build_llt
}

function shrink_component()
{
    mkdir -p ${LOCAL_DIR}/install_comm_dist/lib
    cp -r ${LOCAL_DIR}/install_comm/include ${LOCAL_DIR}/install_comm_dist
    cp -r ${LOCAL_DIR}/install_comm/bin ${LOCAL_DIR}/install_comm_dist
    cp -r ${LOCAL_DIR}/install_comm/lib/*\.so* ${LOCAL_DIR}/install_comm_dist/lib

    mkdir -p ${LOCAL_DIR}/install_llt_dist/lib
    cp -r ${LOCAL_DIR}/install_llt/include ${LOCAL_DIR}/install_llt_dist
    cp -r ${LOCAL_DIR}/install_llt/bin ${LOCAL_DIR}/install_llt_dist
    cp -r ${LOCAL_DIR}/install_llt/lib/*\.so* ${LOCAL_DIR}/install_llt_dist/lib
}

function dist_component()
{
    mkdir -p ${INSTALL_COMPOENT_PATH_NAME}/comm 
    rm -rf "${INSTALL_COMPOENT_PATH_NAME}"/comm/*
    cp -r ${LOCAL_DIR}/install_comm_dist/* "${INSTALL_COMPOENT_PATH_NAME}"/comm
    mkdir -p ${INSTALL_COMPOENT_PATH_NAME}/llt
    rm -rf "${INSTALL_COMPOENT_PATH_NAME}"/llt/*
    cp -r ${LOCAL_DIR}/install_llt_dist/* "${INSTALL_COMPOENT_PATH_NAME}"/llt
}

function clean_component()
{
    cd ${LOCAL_DIR}
    [ -n "${SOURCE_CODE_PATH}" ] && rm -rf "${SOURCE_CODE_PATH}"
    rm -rf install_*
}

function main()
{
    build_component
    shrink_component
    dist_component
    clean_component
}

main
