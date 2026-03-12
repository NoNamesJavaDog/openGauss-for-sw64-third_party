#!/bin/bash
# *************************************************************************
# Copyright: (c) Huawei Technologies Co., Ltd. 2020. All rights reserved
#
#  description: the script that make install dependency
#  date: 2021-01-05
#  version: 1.0
#  history:
#
# *************************************************************************
set -e

ARCH=$(uname -m)
ROOT_DIR=$(cd $(dirname $0)/../../; pwd)

if [ ! -L ${ROOT_DIR}/server ]; then
    echo "ERROR: You need to create link to gaussdb server repo:"
    echo "   ln -s <path/to/your/gaussdb/server/repo> ${ROOT_DIR}/server"
    exit 1
fi

test -f ${ROOT_DIR}/build_all.log && rm -rf ${ROOT_DIR}/build_all.log

# =========================================================================
echo "###### `date`: pldebugger ######"
cd ${ROOT_DIR}/gpl_dependency/pldebugger
sh build.sh  ${ROOT_DIR}/server 2>&1 | tee -a ${ROOT_DIR}/build_all.log

# =========================================================================
echo "###### `date`: postgis ######"
cd ${ROOT_DIR}/gpl_dependency/postgis
sh PostGIS_build_install.sh 2>&1 | tee -a ${ROOT_DIR}/build_all.log

