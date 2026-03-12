#!/bin/bash
# *************************************************************************
# Copyright: (c) Huawei Technologies Co., Ltd. 2022. All rights reserved
#
#  description: the script that build DSS in component
#  date: 2022-11-01
#  version: 3.0.0
#  history:
#
# *************************************************************************

# Clone DSS code to local dir
DSS_REPO=https://gitcode.com/opengauss/DSS.git
DSS_BRANCH=master

echo "clone dss code"
if [ -d DSS ]; then
    rm -rf DSS
fi
git clone ${DSS_REPO} -b ${DSS_BRANCH} DSS
cd DSS

LOCAL_PATH="$(pwd)"
LOCAL_DIR=$(dirname "${LOCAL_PATH}")
ROOT_DIR="${PWD}/../../.."
export PLAT_FORM_STR=$(sh ${LOCAL_DIR}/../../build/get_PlatForm_str.sh)

if [ "$(uname -m)" = "sw_64" ]; then
    # patch cm_thread.c: add sw_64 gettid syscall
    T=$(find . -name "cm_thread.c" 2>/dev/null | head -1)
    [ -n "$T" ] && sed -i 's/#elif (defined __loongarch__)/#elif (defined __sw_64__)\n#include<sys\/syscall.h>\n#define __SYS_GET_SPID SYS_gettid\n#elif (defined __loongarch__)/' "$T"
    # patch cm_spinlock.h: add sw_64 to nop branch (no pause instruction)
    S=$(find . -name "cm_spinlock.h" 2>/dev/null | head -1)
    [ -n "$S" ] && sed -i 's/defined(__loongarch__)/defined(__loongarch__) || defined(__sw_64__)/' "$S"
    # patch cm_memory.h: add sw_64 CM_MFENCE
    M=$(find . -name "cm_memory.h" 2>/dev/null | head -1)
    [ -n "$M" ] && sed -i 's/#elif defined(__loongarch__)/#elif defined(__sw_64__)\n#define CM_MFENCE { __sync_synchronize(); }\n#elif defined(__loongarch__)/' "$M"
    # patch CMakeLists.txt: sw_64 has no -msse4.2
    python3 /root/openGauss-third_party/component/patch_cmake_sw64.py CMakeLists.txt
    # patch dss_blackbox.c: SIGSTKFLT is x86-only
    sed -i 's/SIGSTKFLT, //g' src/service/dss_blackbox.c
fi
cd build/linux/opengauss
sh -x build.sh -3rd "${ROOT_DIR}/output/"
