#!/bin/bash
# *************************************************************************
# Copyright: (c) Huawei Technologies Co., Ltd. 2020. All rights reserved
#
#  description: the script that make install all of binarylibs
#  date: 2020-06-01
#  version: 1.0
#  history:
#
# *************************************************************************
set -e

ROOT_PATH=$(pwd)/../
OUTPUT_PATH=${ROOT_PATH}/output
PLATFORM_BUILD_PATH=${ROOT_PATH}/platform/build
TOOLS_BUILD_PATH=${ROOT_PATH}/buildtools
DEPENDENCY_BUILD_PATH=${ROOT_PATH}/dependency/build
COMPONENT_BUILD_PATH=${ROOT_PATH}/component/build

# clean output dir
if [[ -d ${OUTPUT_PATH} ]]; then
    rm -rf ${OUTPUT_PATH}
fi

# checksum for all package before building
python3 ./checksum.py

echo --------------------------------openssl-------------------------------------------------
start_tm=$(date +%s%N)
[ -f build_result.log ] && rm -rf build_result.log
cd $(pwd)/../dependency/openssl
python3 build.py -m all -f openssl-3.0.9.tar.gz -t "comm|llt" >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[openssl] $use_tm"

echo --------------------------------tassl-------------------------------------------------
start_tm=$(date +%s%N)
[ -f build_result.log ] && rm -rf build_result.log
cd $(pwd)/../tassl
python3 build.py -m all -f TASSL-1.1.1-master.tar.gz -t "comm|llt" >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[openssl] $use_tm"

start_tm=$(date +%s%N)
# build platform
cd ${TOOLS_BUILD_PATH}
sh build_tools.sh

# build platform
cd ${PLATFORM_BUILD_PATH}
sh build_platform.sh

# build dependency
cd ${DEPENDENCY_BUILD_PATH}
sh build_dependency.sh

# build component
cd ${COMPONENT_BUILD_PATH}
sh build_component.sh

end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "total build time:$use_tm"
