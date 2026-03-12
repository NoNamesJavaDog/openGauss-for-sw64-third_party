#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
set -e

PKG_FILE=dfd9365264a060a5096734b7d892e1858b6d2722.zip
SOURCE_DIR=dmlc-core
if [ -d ${SOURCE_DIR} ]; then
    rm -rf ${SOURCE_DIR}
fi
mkdir ${SOURCE_DIR}
unzip ${PKG_FILE} -d ${SOURCE_DIR}/temp

mv ${SOURCE_DIR}/temp/dmlc-core-dfd9365264a060a5096734b7d892e1858b6d2722/* ${SOURCE_DIR}/

rm -rf ${SOURCE_DIR}/temp

