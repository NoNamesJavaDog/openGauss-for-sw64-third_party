#!/bin/bash
# *************************************************************************
# Copyright: (c) Huawei Technologies Co., Ltd. 2022. All rights reserved
#
#  description: the script that build DCF in component
#  date: 2022-03-01
#  version: 3.0.0
#  history:
#
# *************************************************************************

# Clone DCF code to local dir
DCF_REPO=https://gitcode.com/opengauss/DCF.git
DCF_BRANCH=master

echo "clone dcf code"
if [ -d DCF ]; then
    rm -rf DCF
fi
git clone ${DCF_REPO} -b ${DCF_BRANCH} DCF
cd DCF

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
fi
cd build/linux/opengauss
sh -x build.sh -3rd "${ROOT_DIR}/output" -m Release -t cmake
