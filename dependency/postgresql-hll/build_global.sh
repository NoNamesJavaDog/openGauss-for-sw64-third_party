#!/bin/bash
# Copyright © Huawei Technologies Co., Ltd. 2010-2019. All rights reserved.
#  description: the script that make install hll libs
#  date: 2019-7-16
#  modified: 
#  version: 1.0
#  history:

######################################################################
# Parameter setting
######################################################################
set -e
LOCAL_PATH=${0}
FIRST_CHAR=$(expr substr "$LOCAL_PATH" 1 1)
if [ "$FIRST_CHAR" = "/" ]; then
    LOCAL_PATH=${0}
elif [ ${LOCAL_PATH:0:2} = "./" ]; then
    LOCAL_PATH="$(pwd)/${LOCAL_PATH:1}"
else
    LOCAL_PATH="$(pwd)/${LOCAL_PATH}"
fi

LOCAL_DIR=$(dirname "${LOCAL_PATH}")
CONFIG_FILE_NAME=config.ini
BUILD_OPTION=release
ZIP_FILE_NAME=postgresql-hll-2.14.zip
SOURCE_CODE_PATH=postgresql-hll-2.14
LOG_FILE=${LOCAL_DIR}/postgresql-hll-2.14.log
BUILD_PATH=build
BUILD_FAILED=1

ls ${LOCAL_DIR}/${CONFIG_FILE_NAME} >/dev/null 2>&1
if [ $? -ne 0 ]; then
	die "[Error] the file ${CONFIG_FILE_NAME} not exist."
fi

COMPLIE_TYPE_LIST=$(cat ${LOCAL_DIR}/${CONFIG_FILE_NAME} | grep -v '#' | grep -v '^$' | awk -F '=' '{print $2}' | sed  's/|/ /g')
COMPONENT_NAME=$(cat ${LOCAL_DIR}/${CONFIG_FILE_NAME} | grep -v '#' | grep -v '^$' |awk -F '=' '{print $1}'| awk -F '@' '{print $2}')
COMPONENT_TYPE=$(cat ${LOCAL_DIR}/${CONFIG_FILE_NAME} | grep -v '#' | grep -v '^$' | awk -F '@' '{print $1}')
ROOT_DIR="${PWD}/../.."
PLAT_FORM_STR="$(bash ${ROOT_DIR}/build/get_PlatForm_str.sh)"
#PLAT_FORM_STR=$(sh ${LOCAL_DIR}/../../../src/get_PlatForm_str.sh)

ROOT_DIR="${LOCAL_DIR}/../../.."
INSTALL_COMPONENT_PATH_NAME="${LOCAL_DIR}/$PLAT_FORM_STR/postgresql-hll"

if [ "${PLAT_FORM_STR}"X = "Failed"X ]
then
	die "[Error] the plat form is not supported!"
fi

if [ "${COMPONENT_NAME}"X = ""X ]
then
	die "[Error] get component name failed!"
fi

if [ "${COMPONENT_TYPE}"X = ""X ]
then
	die "[Error] get component type failed!"
fi


ROOT_DIR="${LOCAL_DIR}/../../"
INSTALL_COMPONENT_PATH_NAME="${ROOT_DIR}/output/dependency/${PLAT_FORM_STR}/${COMPONENT_NAME}"
mkdir -p $INSTALL_COMPONENT_PATH_NAME/comm
mkdir -p $INSTALL_COMPONENT_PATH_NAME/llt

