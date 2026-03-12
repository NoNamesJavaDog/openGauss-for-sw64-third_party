#!/bin/bash
#  Copyright (c) Huawei Technologies Co., Ltd. 2010-2018. All rights reserved.
#  description: the script that make install libevent
#  date: 2024-06-08
#  version: -1.0
#  history:
#    2024-06-08 100 LOC.

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
TAR_FILE_NAME=aws-sdk-cpp-1.11.712.tar.gz
SOURCE_CODE_PATH=aws-sdk-cpp-1.11.712
LOG_FILE=${LOCAL_DIR}/build_aws.log
ROOT_DIR="${LOCAL_DIR}/../../"
CURL_LIB="${ROOT_DIR}/output/kernel/dependency/libcurl/comm/lib/libcurl.so"
CURL_INCLUDE="${ROOT_DIR}/output/kernel/dependency/libcurl/comm/include"
CRYPTO_LIB="${ROOT_DIR}/output/kernel/dependency/openssl/comm/lib/libcrypto.so"
CRYPTO_INCLUDE="${ROOT_DIR}/output/kernel/dependency/openssl/comm/include"
CRYPTO_STATIC="${ROOT_DIR}/output/kernel/dependency/openssl/comm/lib/libcrypto_static.a"
ZLIB_DIR="${ROOT_DIR}/output/kernel/dependency/zlib1.2.11/comm"
ZLIB_INCLUDE="${ROOT_DIR}/output/kernel/dependency/zlib1.2.11/comm/include"
ZLIB_LIB="${ROOT_DIR}/output/kernel/dependency/zlib1.2.11/comm/lib/libz.so"
OPENSSL_DIR="${ROOT_DIR}/output/kernel/dependency/openssl/comm"
INSTALL_COMPOENT_PATH_NAME="${ROOT_DIR}/output/kernel/dependency/aws-sdk-cpp"

log()
{
    echo "[Build libaws-sdk-cpp] "$(date +%y-%m-%d" "%T)": $@"
    echo "[Build libaws-sdk-cpp] "$(date +%y-%m-%d" "%T)": $@" >> "$LOG_FILE" 2>&1
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

    if [ $? -ne 0 ]; then
        die "failed to patch file."
    fi
    mkdir -p ${LOCAL_DIR}/${SOURCE_CODE_PATH}/build_comm
    mkdir -p ${LOCAL_DIR}/install_comm
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}/build_comm
    cmake .. -DBUILD_ONLY="s3" \
            -DCMAKE_CXX_FLAGS="-w -std=c++11 -D_GLIBCXX_USE_CXX11_ABI=0 -fstack-protector-strong -D_FORTIFY_SOURCE=2 -O2 " \
            -DCMAKE_C_FLAGS="-w -std=c99 -D_GLIBCXX_USE_CXX11_ABI=0 -fstack-protector-strong -D_FORTIFY_SOURCE=2 -O2 " \
            -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-z,relro,-z,now" \
            -DCMAKE_SKIP_RPATH=TRUE \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_INSTALL_PREFIX=${LOCAL_DIR}/install_comm \
            -DCURL_INCLUDE_DIR=${CURL_INCLUDE} \
            -DCURL_LIBRARY=${CURL_LIB} \
            -Dcrypto_INCLUDE_DIR=${CRYPTO_INCLUDE} \
            -Dcrypto_SHARED_LIBRARY=${CRYPTO_LIB} \
            -Dcrypto_STATIC_LIBRARY=${CRYPTO_STATIC} \
            -DZLIB_ROOT=${ZLIB_DIR} \
            -DZLIB_INCLUDE_DIRS=${ZLIB_INCLUDE} \
            -DZLIB_LIBRARIES=${ZLIB_LIB} \
            -DOPENSSL_ROOT_DIR=${OPENSSL_DIR} \
            -DENABLE_TESTING=OFF
    make -j4
    make install
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
    rm -rf build_comm

    mkdir -p ${LOCAL_DIR}/${SOURCE_CODE_PATH}/build_llt
    mkdir -p ${LOCAL_DIR}/install_llt
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}/build_llt
    cmake .. -DBUILD_ONLY="s3" \
        -DCMAKE_CXX_FLAGS="-w -std=c++11 -D_GLIBCXX_USE_CXX11_ABI=0 -fstack-protector-strong -D_FORTIFY_SOURCE=2 -O2 " \
        -DCMAKE_C_FLAGS="-w -std=c99 -D_GLIBCXX_USE_CXX11_ABI=0 -fstack-protector-strong -D_FORTIFY_SOURCE=2 -O2 " \
        -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-z,relro,-z,now" \
        -DCMAKE_SKIP_RPATH=TRUE \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=${LOCAL_DIR}/install_llt \
        -DCURL_INCLUDE_DIR=${CURL_INCLUDE} \
        -DCURL_LIBRARY=${CURL_LIB} \
        -Dcrypto_INCLUDE_DIR=${CRYPTO_INCLUDE} \
        -Dcrypto_SHARED_LIBRARY=${CRYPTO_LIB} \
        -Dcrypto_STATIC_LIBRARY=${CRYPTO_STATIC} \
        -DZLIB_ROOT=${ZLIB_DIR} \
        -DZLIB_INCLUDE_DIRS=${ZLIB_INCLUDE} \
        -DZLIB_LIBRARIES=${ZLIB_LIB} \
        -DOPENSSL_ROOT_DIR=${OPENSSL_DIR} \
        -DENABLE_TESTING=OFF
    make -j4
    make install
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
    rm -rf build_llt
}

function shrink_component()
{
    mkdir -p ${LOCAL_DIR}/install_comm_dist/lib
    cp -r ${LOCAL_DIR}/install_comm/include ${LOCAL_DIR}/install_comm_dist
    LIB_DIR_COMM=${LOCAL_DIR}/install_comm/lib64; [ -d $LIB_DIR_COMM ] || LIB_DIR_COMM=${LOCAL_DIR}/install_comm/lib; cp -r ${LIB_DIR_COMM}/*\.so* ${LOCAL_DIR}/install_comm_dist/lib

    mkdir -p ${LOCAL_DIR}/install_llt_dist/lib
    cp -r ${LOCAL_DIR}/install_llt/include ${LOCAL_DIR}/install_llt_dist
    LIB_DIR_LLT=${LOCAL_DIR}/install_llt/lib64; [ -d $LIB_DIR_LLT ] || LIB_DIR_LLT=${LOCAL_DIR}/install_llt/lib; cp -r ${LIB_DIR_LLT}/*\.so* ${LOCAL_DIR}/install_llt_dist/lib
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
