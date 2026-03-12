#!/bin/bash
#  Copyright (c) Huawei Technologies Co., Ltd. 2010-2022. All rights reserved.
#  description: the script that make mysql_fdw
#  date: 2022-01-27
#  version: 1.0
#  history:
#    2022-03-23 fit global syscache
#    2020-12-16 first version
#    2022-01-27 copy uncompress file to binarylibs

set -e

SOURCE_FILE=mysql_fdw-REL-2_5_5.tar.gz
SOURCE_DIR=mysql_fdw-REL-2_5_5

## create target path
LOCAL_PATH=${0}
FIRST_CHAR=$(expr substr "$LOCAL_PATH" 1 1)
if [ "$FIRST_CHAR" = "/" ]; then
    LOCAL_PATH=${0}
else
    LOCAL_PATH="$(pwd)/${LOCAL_PATH}"
fi
LOCAL_DIR=$(dirname "${LOCAL_PATH}")
ROOT_DIR="${LOCAL_DIR}/../../"
TARGET_PATH=${ROOT_DIR}/output/kernel/dependency/mysql_fdw
[ -d ${TARGET_PATH} ] && rm -rf ${TARGET_PATH}/*
mkdir -pv ${TARGET_PATH}

## uncompress source file and patch
if [ -d ${SOURCE_DIR} ]; then
    rm -rf ${SOURCE_DIR}
fi
mkdir ${SOURCE_DIR}
tar -zxf $SOURCE_FILE -C $SOURCE_DIR --strip-components 1
patch -p0 -d ${SOURCE_DIR} < opengauss_mysql_fdw-2.5.5_patch.patch

# patch for global syscache
cd ${SOURCE_DIR}
patch -p1 < ../gsc.patch
cd ..

# patch for adapting join push down interface
cd ${SOURCE_DIR}
patch -p1 < ../opengauss_mysql_fdw-2.5.5_patch_20221230.patch
patch -p1 < ../opengauss-reltargetlist.patch
cd ..

## move to target path
mv ${SOURCE_DIR}/* ${TARGET_PATH}/



