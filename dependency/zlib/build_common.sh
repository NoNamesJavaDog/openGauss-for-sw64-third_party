#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
#  description: the script that make install zlib
#  date: 2015-8-20
#  version: 1.0
#  history:
#    2015-12-19 update to zlib1.2.8
#    2017-04-21 update to zlib1.2.11
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

TAR_FILE_NAME=zlib-1.2.12.tar.gz
SOURCE_CODE_PATH=zlib

LOG_FILE=${LOCAL_DIR}/build_zlib.log
BUILD_FAILED=1

ls ${LOCAL_DIR}/${CONFIG_FILE_NAME} >/dev/null 2>&1
if [ $? -ne 0 ]; then
    die "[Error] the file ${CONFIG_FILE_NAME} not exist."
fi

COMPLIE_TYPE_LIST=$(cat ${LOCAL_DIR}/${CONFIG_FILE_NAME} | grep -v '#' | grep -v '^$' | awk -F '=' '{print $2}' | sed  's/|/ /g')
COMPONENT_NAME=$(cat ${LOCAL_DIR}/${CONFIG_FILE_NAME} | grep -v '#' | grep -v '^$' |awk -F '=' '{print $1}'| awk -F '@' '{print $2}')
COMPONENT_TYPE=$(cat ${LOCAL_DIR}/${CONFIG_FILE_NAME} | grep -v '#' | grep -v '^$' | awk -F '@' '{print $1}')

if [ "${COMPONENT_NAME}"X = ""X ]
then
    die "[Error] get component name failed!"
fi

if [ "${COMPONENT_TYPE}"X = ""X ]
then
    die "[Error] get component type failed!"
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
    echo "[Build zlib] $(date +%y-%m-%d' '%T): $@"
    echo "[Build zlib] $(date +%y-%m-%d' '%T): $@" >> "$LOG_FILE" 2>&1
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
