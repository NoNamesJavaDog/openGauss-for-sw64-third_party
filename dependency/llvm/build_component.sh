#!/bin/bash
# Perform PL/Java lib installation.
# Copyright (c) Huawei Technologies Co., Ltd. 2010-2018. All rights reserved.
# description: the script that make install pljava libs
# date: 2019-5-16
# modified:
# version: 1.0
# history:

WORK_PATH="$(dirname ${0})"
source "${WORK_PATH}/build_global.sh"

#######################################################################
# build and install component
#######################################################################
function build_llvm()
{
    
    cd ${LOCAL_DIR}
    if [ -d ${SOURCE_CODE_PATH} ]; then
        rm -rf ${SOURCE_CODE_PATH}
    fi
    mkdir ${SOURCE_CODE_PATH}
    tar -zxf $TAR_FILE_NAME -C $SOURCE_CODE_PATH --strip-components 1
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
    patch -p1 < ../CVE-2024-31852.patch
    # Fix config.guess for sw_64
    cp /usr/share/automake-1.16/config.guess ${LOCAL_DIR}/${SOURCE_CODE_PATH}/llvm/cmake/config.guess
    chmod +x ${LOCAL_DIR}/${SOURCE_CODE_PATH}/llvm/cmake/config.guess
    # patch -p1 < ../0001-llvm.patch
    # patch -p1 < ../0002-llvm.patch
    # patch -p1 < ../0003-llvm.patch
    # patch -p1 < ../0004-llvm.patch
    # patch -p1 < ../0005-llvm.patch
    # patch -p1 < ../0006-llvm.patch
    # if [ $? -ne 0 ]; then
    #     die "[Error] change dir to $SRC_DIR failed."
    # fi
    test -d build || mkdir build
    rm -fr ./build/*
    cd ./build
    log "[Notice] llvm start configure"
    echo ${COMPILE_TYPE_LIST}
    for COMPILE_TYPE in ${COMPILE_TYPE_LIST}
    do
        case "${COMPILE_TYPE}" in
            comm|llt|tool)
                # when build with 'tool' option, LLVM libraries are required too.
                mkdir -p ${LOCAL_DIR}/install_comm
                log "[Notice] running cmake ..."
                # sort the defined flags in alphabetic order
                cmake -G "Unix Makefiles" \
                -DCMAKE_BUILD_TYPE=Release \
                -DCLANG_INCLUDE_TESTS=OFF \
                -DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF \
                -DCLANG_TOOL_CLANG_CHECK_BUILD=OFF \
                -DCLANG_TOOL_CLANG_EXTDEF_MAPPING_BUILD=OFF\
                -DCLANG_TOOL_CLANG_FORMAT_BUILD=OFF \
                -DCLANG_TOOL_CLANG_IMPORT_TEST_BUILD=OFF \
                -DCLANG_TOOL_CLANG_OFFLOAD_BUNDLER_BUILD=OFF \
                -DCLANG_TOOL_CLANG_RENAME_BUILD=OFF \
                -DCLANG_TOOL_CLANG_REFACTOR_BUILD=OFF \
                -DCMAKE_C_FLAGS='-fno-aggressive-loop-optimizations -fexceptions' \
                -DCMAKE_C_FLAGS_RELEASE='-O2 -DNDEBUG -D_FORTIFY_SOURCE=2' \
                -DCMAKE_CXX_FLAGS='-fno-aggressive-loop-optimizations -D_GLIBCXX_USE_CXX11_ABI=0 -fexceptions' \
                -DCMAKE_CXX_FLAGS_RELEASE='-O2 -DNDEBUG -D_FORTIFY_SOURCE=2' \
                -DCMAKE_INSTALL_PREFIX=${LOCAL_DIR}/install_comm \
                -DLLVM_ENABLE_ASSERTIONS=ON \
                -DLLVM_ENABLE_BINDINGS=OFF \
                -DLLVM_ENABLE_RTTI=ON \
                -DLLVM_TARGETS_TO_BUILD=${BUILD_TARGET} \
                -DLLVM_USE_PERF=ON \
                ../llvm
                ;;
            sanitizer)
                mkdir -p ${LOCAL_DIR}/install_comm
                log "[Notice] running cmake ..."
                # sort the defined flags in alphabetic order
                cmake -G "Unix Makefiles" \
                -DCMAKE_BUILD_TYPE=Debug \
                -DCLANG_INCLUDE_TESTS=OFF \
                -DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF \
                -DCLANG_TOOL_CLANG_CHECK_BUILD=OFF \
                -DCLANG_TOOL_CLANG_EXTDEF_MAPPING_BUILD=OFF\
                -DCLANG_TOOL_CLANG_FORMAT_BUILD=OFF \
                -DCLANG_TOOL_CLANG_IMPORT_TEST_BUILD=OFF \
                -DCLANG_TOOL_CLANG_OFFLOAD_BUNDLER_BUILD=OFF \
                -DCLANG_TOOL_CLANG_RENAME_BUILD=OFF \
                -DCLANG_TOOL_CLANG_REFACTOR_BUILD=OFF \
                -DCMAKE_C_FLAGS='-fno-aggressive-loop-optimizations -fexceptions -static-libasan' \
                -DCMAKE_C_FLAGS_RELEASE='-O0 -DDEBUG' \
                -DCMAKE_CXX_FLAGS='-fno-aggressive-loop-optimizations -D_GLIBCXX_USE_CXX11_ABI=0 -fexceptions -static-libasan' \
                -DCMAKE_CXX_FLAGS_RELEASE='-O0 -DDEBUG' \
                -DCMAKE_INSTALL_PREFIX=${LOCAL_DIR}/install_comm \
                -DLLVM_ENABLE_ASSERTIONS=ON \
                -DLLVM_ENABLE_BINDINGS=OFF \
                -DLLVM_ENABLE_RTTI=ON \
                -DLLVM_TARGETS_TO_BUILD=${BUILD_TARGET} \
                -DLLVM_USE_PERF=ON \
                -DLLVM_USE_SANITIZER=Address \
                ../llvm
                ;;
            *)
                log "Internal Error: option processing error: $1"
                log "please write right paramenter in ${CONFIG_FILE_NAME}"
                die "[Error] llvm not supported build type."
                exit 1
        esac

        if [ $? -ne 0 ]; then
           die "[Error] llvm configure failed."
        fi
        log "[Notice] llvm End configure"
        log "[Notice] llvm using \"${COMPILE_TYPE_LIST}\" Begin make"
        make -s -j16
        if [ $? -ne 0 ]; then
           die "llvm make failed."
        fi
        log "[Notice] llvm End make"

        log "[Notice] llvm using \"${COMPILE_TYPE_LIST}\" Begin make install"
        make install
        if [ $? -ne 0 ]; then
           die "llvm make install failed."
        fi
        log "[Notice] llvm End make install"
        # llvm has no distclean, using clean here.
        make clean
    done
}

function build_clang()
{
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}/
    test -d build || mkdir build
    rm -fr ./build/*
    cd ./build

    log "[Notice] clang start configure"
    echo ${COMPILE_TYPE_LIST}
    for COMPILE_TYPE in ${COMPILE_TYPE_LIST}
    do
        case "${COMPILE_TYPE}" in
            comm|llt|sanitizer)
                log "[Notice] null build action for clang ..."
                return
                ;;
            tool)
                # No santizer on clang, too many issues with it
                mkdir -p ${LOCAL_DIR}/install_comm
                log "[Notice] running cmake ..."
                # sort the defined flags in alphabetic order
                cmake -G "Unix Makefiles" \
                -DCMAKE_BUILD_TYPE=Release \
                -DCLANG_INCLUDE_TESTS=OFF \
                -DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF \
                -DCLANG_TOOL_CLANG_CHECK_BUILD=OFF \
                -DCLANG_TOOL_CLANG_EXTDEF_MAPPING_BUILD=OFF \
                -DCLANG_TOOL_CLANG_FORMAT_BUILD=OFF \
                -DCLANG_TOOL_CLANG_IMPORT_TEST_BUILD=OFF \
                -DCLANG_TOOL_CLANG_OFFLOAD_BUNDLER_BUILD=OFF \
                -DCLANG_TOOL_CLANG_RENAME_BUILD=OFF \
                -DCLANG_TOOL_CLANG_REFACTOR_BUILD=OFF \
                -DCLANG_PLUGIN_SUPPORT=OFF \
                -DCMAKE_C_FLAGS='-fno-aggressive-loop-optimizations -fexceptions' \
                -DCMAKE_C_FLAGS_RELEASE='-O2 -DNDEBUG' \
                -DCMAKE_CXX_FLAGS='-fno-aggressive-loop-optimizations -D_GLIBCXX_USE_CXX11_ABI=0 -fexceptions' \
                -DCMAKE_CXX_FLAGS_RELEASE='-O2 -DNDEBUG' \
                -DCMAKE_INSTALL_PREFIX=${LOCAL_DIR}/install_tool \
                -DLLVM_ENABLE_ASSERTIONS=ON  \
                -DLLVM_TARGETS_TO_BUILD=${BUILD_TARGET} \
                -DLLVM_USE_PERF=ON \
                ../clang
                ;;
            *)
                log "Internal Error: option processing error: $1"
                log "please write right paramenter in ${CONFIG_FILE_NAME}"
                die "[Error] clang not supported build type."
                exit 1
        esac

        if [ $? -ne 0 ]; then
           die "[Error] clang configure failed."
        fi
        log "[Notice] clang End configure"
        log "[Notice] clang using \"${COMPILE_TYPE_LIST}\" Begin make"
        make -s -j16
        if [ $? -ne 0 ]; then
           die "clang make failed."
        fi
        log "[Notice] clang End make"

        log "[Notice] clang using \"${COMPILE_TYPE_LIST}\" Begin make install"
        make install
        if [ $? -ne 0 ]; then
           die "clang make install failed."
        fi
        log "[Notice] clang End make install"

        make clean
    done
}

function build_component()
{
    build_llvm

    export PATH=${LOCAL_DIR}/install_comm/bin:${PATH}
    export LD_LIBRARY_PATH=${LOCAL_DIR}/install_comm/lib:${LD_LIBRARY_PATH}
    build_clang
}

#######################################################################
# clean component
#######################################################################
function clean_component()
{
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
    if [ $? -ne 0 ]; then
        die "[Error] cd ${LOCAL_DIR}/${SOURCE_CODE_PATH} failed."
    fi

    cd ${LOCAL_DIR}
    if [ $? -ne 0 ]; then
        die "[Error] cd ${LOCAL_DIR} failed."
    fi
    test -d  "${SOURCE_CODE_PATH}/build" && rm -rf ${SOURCE_CODE_PATH}/build
    rm -rf install_*

    log "[Notice] llvm clean has been finished!"
}
