#!/bin/bash
# *************************************************************************
# Copyright: (c) Huawei Technologies Co., Ltd. 2022. All rights reserved
#
#  description: the script that build CBB in component
#  date: 2022-03-01
#  version: 3.0.0
#  history:
#
# *************************************************************************

# Clone CBB code to local dir
CBB_REPO=https://gitcode.com/opengauss/CBB.git
CBB_BRANCH=master

echo "clone dcc code"
if [ -d CBB ]; then
    rm -rf CBB
fi
git clone ${CBB_REPO} -b ${CBB_BRANCH} CBB
cd CBB

LOCAL_PATH="$(pwd)"
LOCAL_DIR=$(dirname "${LOCAL_PATH}")
ROOT_DIR="${PWD}/../../.."
export PLAT_FORM_STR=$(sh ${LOCAL_DIR}/../../build/get_PlatForm_str.sh)

if [ "$(uname -m)" = "sw_64" ]; then
    # sw_64: no bundled gcc, create symlinks to system gcc for inner build.sh
    FAKE_GCC="${ROOT_DIR}/output/buildtools/gcc7.3"
    mkdir -p ${FAKE_GCC}/gcc/bin ${FAKE_GCC}/gcc/lib64
    for d in isl mpc mpfr gmp; do mkdir -p ${FAKE_GCC}/$d/lib; done
    ln -sf $(which gcc) ${FAKE_GCC}/gcc/bin/gcc
    ln -sf $(which g++) ${FAKE_GCC}/gcc/bin/g++
    export CC=$(which gcc)
    export CXX=$(which g++)
    # patch cm_thread.c for sw_64 gettid syscall
    sed -i 's/#elif (defined __loongarch__)/#elif (defined __sw_64__)\n#include<sys\/syscall.h>\n#define __SYS_GET_SPID SYS_gettid\n#elif (defined __loongarch__)/' src/cm_concurrency/cm_thread.c
    # patch cm_spinlock.h: add sw_64 to nop branch (sw_64 has no pause instruction)
    sed -i 's/defined(__loongarch__)/defined(__loongarch__) || defined(__sw_64__)/' src/cm_concurrency/cm_spinlock.h
    # patch cm_memory.h: add sw_64 CM_MFENCE (compiler memory barrier)
    sed -i 's/#elif defined(__loongarch__)/#elif defined(__sw_64__)\n#define CM_MFENCE { __sync_synchronize(); }\n#elif defined(__loongarch__)/' src/cm_utils/cm_memory.h
else
    cp -r ${GCC_PATH} ${ROOT_DIR}/output/buildtools/
fi
sh -x build.sh -3rd "${ROOT_DIR}/output"
