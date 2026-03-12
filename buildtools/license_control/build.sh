#!/bin/bash
# Copyright (c): 2012-2020, Huawei Tech. Co., Ltd.
set -e
export TARGET_PATH=$(pwd)/../../output/buildtools/license_control/

if [ ! -d ${TARGET_PATH} ];then
  mkdir -p ${TARGET_PATH}
fi

cp encrypted_version_file.py ${TARGET_PATH}
cp GaussDB_features_list ${TARGET_PATH}

