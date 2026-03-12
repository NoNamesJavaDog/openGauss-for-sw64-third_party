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

[ -f build_all.log ] && rm -rf build_all.log

echo ------------------------------cJSON------------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../cJSON
sh build.sh -m all >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[cJSON] is " $use_tm
echo ------------------------------jemalloc---------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../jemalloc
if [ "$ARCH"x != "loongarch64"x ];then
    python3 build.py -m all -t "release|debug" -f jemalloc-5.3.0.tar.bz2 >>../build/build_result.log
fi
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[jemalloc] is " $use_tm
echo ------------------------------libcgroup--------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../libcgroup
python3 build.py -m all -t "comm|llt" -f libcgroup-2.0.3.tar.gz >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[libcgroup] is " $use_tm
echo ------------------------------fio--------------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../fio
python3 build.py -m all -t comm -f fio-3.30.tar.gz >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[fio] is " $use_tm
echo -------------------------------llvm------------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../llvm
if [[ "$ARCH"x = "sw_64"x ]];then
    # sw_64: copy system LLVM 13 (has Sw64 backend) to output instead of building from source
    _LLVM_OUT="$(pwd)/../../output/kernel/dependency/llvm"
    mkdir -p $_LLVM_OUT/comm/bin $_LLVM_OUT/comm/include $_LLVM_OUT/comm/lib
    cp /usr/bin/llvm-config $_LLVM_OUT/comm/bin/
    cp -r /usr/include/llvm $_LLVM_OUT/comm/include/
    cp -r /usr/include/llvm-c $_LLVM_OUT/comm/include/
    cp /usr/lib/libLLVM*.a $_LLVM_OUT/comm/lib/
    echo "[llvm] sw_64: using system LLVM 13 Sw64"
elif [[ "$ARCH"x != "loongarch64"x ]];then
    bash -x build.sh -m all -c comm >>../build/build_result.log
fi
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo $use_tm
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

#第一层依赖
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

#无依赖
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
echo ---------------------------------tornado--------------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../tornado
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[tornado] $use_tm"
echo -------------------------------------dmlc-core----------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../dmlc-core
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[dmlc-core] $use_tm"
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

#有依赖
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
echo -----------------------------------------zlib--------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../zlib
sh build.sh -m all >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[zlib] $use_tm"
echo -----------------------------------------boost-------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../boost
sh build.sh -m all >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[boost] $use_tm"
# echo ----------------------------------------brotli-------------------------------------------
# start_tm=$(date +%s%N)
# cd $(pwd)/../brotli
# sh build.sh >>../build/build_result.log
# end_tm=$(date +%s%N)
# use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
# echo "[brotli] $use_tm"
echo -----------------------------------------zstd--------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../zstd
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[zstd] $use_tm"
echo --------------------------------------kerberos-------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../kerberos
python3 build.py -m all -t "comm|llt" -f krb5-1.20.1-final.tar.gz >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[kerberos] $use_tm"
echo ---------------------------------------libcurl-------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../libcurl
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[libcurl] $use_tm"
echo --------------------------------------libiconv-------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../libiconv
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[libiconv] $use_tm"
echo ---------------------------------------nghttp2------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../nghttp2
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[nghttp2] $use_tm"
echo ----------------------------------------pcre---------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../pcre
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[pcre] $use_tm"
echo ---------------------------------------sqlparse-----------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../sqlparse
sh build.sh -m build >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[sqlparse] $use_tm"
echo ---------------------------------------masstree-----------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../masstree
if [[ "$ARCH"x != "loongarch64"x ]];then
    bash build.sh >>../build/build_result.log
fi
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[masstree] $use_tm"
echo ---------------------------------------xgboost-----------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../xgboost
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[libxgboost] $use_tm"
echo ---------------------------------------libevent------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../libevent
sh build.sh >> ../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[libevent] $use_tm"
echo ---------------------------------------aws-sdk-cpp------------------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../aws-sdk-cpp
sh build.sh >> ../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[aws-sdk-cpp] $use_tm"

# only copy
echo ---------------------------------------oracle_fdw-----------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../oracle_fdw
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[oracle_fdw] $use_tm"
echo ---------------------------------------mysql_fdw-----------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../mysql_fdw
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[mysql_fdw] $use_tm"
echo ---------------------------------------text-splitter---------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../text-splitter
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[text-splitter] $use_tm"
echo ---------------------------------------tokenizers---------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../tokenizers
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[tokenizers] $use_tm"
echo ---------------------------------------onnxruntime---------------------------------
start_tm=$(date +%s%N)
cd $(pwd)/../onnxruntime
sh build.sh >>../build/build_result.log
end_tm=$(date +%s%N)
use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
echo "[onnxruntime] $use_tm"

