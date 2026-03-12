#!/bin/bash
# *************************************************************************
# Copyright: (c) Huawei Technologies Co., Ltd. 2020. All rights reserved
#
#  description: the script that make install dependency
#  date: 2020-10-21
#  version: 1.0
#  history:
#
# *************************************************************************
set -e

ARCH=`uname -m`
ROOT_DIR="${PWD}/.."
PLATFORM="$(bash ${ROOT_DIR}/build/get_PlatForm_str.sh)"

[ -f build_tools.log ] && rm -rf build_tools.log
echo --------------------------------python3-------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/python3
sh ./build.sh >> build_tools.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[python3] $use_tm"
cd ..

echo ---------------------------license_control---------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/license_control
sh ./build.sh >> build_tools.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[license_control] $use_tm"

cp -a $(pwd)/../server_key $(pwd)/../../output/buildtools/
