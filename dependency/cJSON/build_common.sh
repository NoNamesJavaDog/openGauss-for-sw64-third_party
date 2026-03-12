#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2010-2022. All rights reserved.
# description: the script that make install cjson
# date: 2020-08-10
# version: 2.0
# history:
# 2019-5-5 update to cjson 1.7.11 from 1.7.7
# 2019-12-28 fix buildcheck warning
# 2020-06-22 fix buildcheck warning
# 2020-08-10 update to cjson 1.7.13 from 1.7.11

set -e

######################################################################
# Parameter setting
######################################################################
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

TAR_FILE_NAME=v1.7.17.tar.gz
SOURCE_CODE_PATH=cJSON-1.7.17

LOG_FILE=${LOCAL_DIR}/build_cjson.log
BUILD_FAILED=1

ls ${LOCAL_DIR}/${CONFIG_FILE_NAME} >/dev/null 2>&1
if [ $? -ne 0 ]; then
    die "[Error] the file ${CONFIG_FILE_NAME} not exist."
fi

COMPLIE_TYPE_LIST=$(cat ${LOCAL_DIR}/${CONFIG_FILE_NAME} | grep -v '#' | grep -v '^$' | awk -F '=' '{print $2}' | sed  's/|/ /g')
COMPONENT_NAME=$(cat ${LOCAL_DIR}/${CONFIG_FILE_NAME} | grep -v '#' | grep -v '^$' |awk -F '=' '{print $1}'| awk -F '@' '{print $2}')

if [ "${COMPONENT_NAME}"X = ""X ]
then
    die "[Error] get component name failed!"
fi

ROOT_DIR="${LOCAL_DIR}/../../"
INSTALL_COMPOENT_PATH_NAME="${ROOT_DIR}/output/kernel/dependency/${COMPONENT_NAME}"

#######################################################################
## print help information
#######################################################################
function print_help()
{
    echo "Usage: $0 [OPTION]
    -h|--help               show help information
    -m|--build_option       provode type of operation, values of paramenter is build, shrink, dist or clean
    "
}

#######################################################################
#  Print log.
#######################################################################
log()
{
    echo "[Build cjson] $(date +%y-%m-%d' '%T): $@"
    echo "[Build cjson] $(date +%y-%m-%d' '%T): $@" >> "$LOG_FILE" 2>&1
}

#######################################################################
#  print log and exit.
#######################################################################
die()
{
    log "$@"
    echo "$@"
    exit $BUILD_FAILED
}

