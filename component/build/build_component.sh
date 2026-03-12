#!/bin/bash
# *************************************************************************
# Copyright: (c) Huawei Technologies Co., Ltd. 2022. All rights reserved
#
#  description: the script that build component
#  date: 2022-03-01
#  version: 3.0.0
#  history:
#
# *************************************************************************

set -e

ARCH=$(uname -m)
ROOT_DIR="${PWD}/../.."
PLATFORM="$(bash ${ROOT_DIR}/build/get_PlatForm_str.sh)"

[ -f build_all.log ] && rm -rf build_all.log
echo ------------------------------CBB----------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../cbb
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[CBB] is " $use_tm
echo ------------------------------DCF----------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../dcf
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[DCF] is " $use_tm
echo ------------------------------DCC----------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../dcc
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[DCC] is " $use_tm
echo ------------------------------DMS----------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../dms
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[DMS] is " $use_tm
echo ------------------------------DSS----------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../dss
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[DSS] is " $use_tm
