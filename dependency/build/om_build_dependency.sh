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

ARCH=$(uname -m)
ROOT_DIR="${PWD}/../.."
PLATFORM="$(bash ${ROOT_DIR}/build/get_PlatForm_str.sh)"

[ -f build_all.log ] && rm -rf build_all.log

echo --------------------------------openssl-------------------------------------------------
start_tm=$(date +%s%N)
[ -f build_result.log ] && rm -rf build_result.log
cd $(pwd)/../openssl
python3 build.py -m all -f openssl-3.0.9.tar.gz -t "comm|llt" >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[openssl] $use_tm"

echo -------------------------------asn1crypto-------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../asn1crypto
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[asn1crypto] $use_tm"

echo ---------------------------------six-----------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../six
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[six] $use_tm"

echo -------------------------------ipaddres--------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../ipaddress
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[ipaddress] $use_tm"

echo -------------------------------pycparser-------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../pycparser
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[pycparser] $use_tm"

echo ---------------------------------cffi----------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../cffi
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[cffi] $use_tm"

echo -------------------------------cryptography----------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../cryptography
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[cryptography] $use_tm"

echo ---------------------------------bcrypt--------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../bcrypt
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[bcrypt] $use_tm"

echo ---------------------------------bottle--------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../bottle
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[bottle] $use_tm"

echo ----------------------------------idna---------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../idna
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[idna] $use_tm"

echo ----------------------------------netifaces----------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../netifaces
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[netifaces] $use_tm"

echo -------------------------------------paste-----------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../paste
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[paste] $use_tm"

echo -------------------------------------psutil----------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../psutil
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[psutil] $use_tm"

echo -------------------------------------pyasn1----------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../pyasn1
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[pyasn1] $use_tm"

echo --------------------------------------pynacl---------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../pynacl
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[pynacl] $use_tm"

echo -----------------------------------paramiko----------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../paramiko
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[paramiko] $use_tm"

echo --------------------------------------pyOpenSSL------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../pyOpenSSL
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[pyOpenSSL] $use_tm"

