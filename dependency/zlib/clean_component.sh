#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
#  description: the script that make install zlib
#  date: 2015-8-20
#  version: 1.0
#  history:
#    2015-12-19 update to zlib1.2.8
#    2017-04-21 update to zlib1.2.11

#######################################################################
# clean component 
#######################################################################
set -e
function clean_component()
{
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
    if [ $? -ne 0 ]; then
        die "[Error] cd ${LOCAL_DIR}/${SOURCE_CODE_PATH} failed."
    fi

    make clean

    cd ${LOCAL_DIR}
    if [ $? -ne 0 ]; then
        die "[Error] cd ${LOCAL_DIR} failed."
    fi
    if [ -d "${SOURCE_CODE_PATH}" ]; then
        rm -rf ${SOURCE_CODE_PATH}
    fi
    rm -rf install_*

    log "[Notice] zlib clean has been finished!"
}
