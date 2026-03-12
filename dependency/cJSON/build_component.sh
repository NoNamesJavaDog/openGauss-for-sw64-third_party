#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2010-2022. All rights reserved.
# description: the script that make install cjson
# date: 2020-08-10
# version: 2.0
# history:
# 2019-5-5 update to cjson 1.7.11 from 1.7.7
# 2019-12-28 fix buildcheck warning
# 2020-06-22 fix buildcheck warning
# 2020-08-10 update to cjson 1.7.13 from 1.7.11

set -e

#######################################################################
# build and install component
#######################################################################
function build_component()
{
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}

    if [ $? -ne 0 ]; then
        die "[Error] change dir to $SRC_DIR failed."
    fi

    for COMPILE_TYPE in ${COMPLIE_TYPE_LIST}
    do
        case "${COMPILE_TYPE}" in
            release)
                die "[Error] cjson not supported build type."
                ;;
            debug)
                die "[Error] cjson not supported build type."
                ;;
            release_llt)
                die "[Error] cjson not supported build type."
                ;;
            debug_llt)
                die "[Error] cjson not supported build type."
                ;;
            comm|llt)
                mkdir -p ${LOCAL_DIR}/install_${COMPILE_TYPE}
                log "[Notice] cjson using \"${COMPILE_TYPE}\" Begin make"
                
                mkdir tmp_build
                cd tmp_build
                cmake .. -DENABLE_CJSON_UTILS=ON -DENABLE_SAFE_STACK=ON -DCMAKE_PROJECT_INCLUDE=${LOCAL_DIR}/${SOURCE_CODE_PATH}/../project_include.cmake -DCMAKE_INSTALL_PREFIX=${LOCAL_DIR}/install_${COMPILE_TYPE}
                make
                ;;
            *)
                log "Internal Error: option processing error: $1"   
                log "please write right paramenter in ${CONFIG_FILE_NAME}"
                exit 1
        esac
 
        if [ $? -ne 0 ]; then
            die "cjson make failed."
        fi
        log "[Notice] cjson End make" 

        log "[Notice] cjson using \"${COMPILE_TYPE}\" Begin make install" 
        make install
        cd ${LOCAL_DIR}/install_${COMPILE_TYPE}
        if [ -d lib64 ]; then mv lib64 lib; fi
        if [ $? -ne 0 ]; then
           die "[Error] cjson make install failed."
        fi
        log "[Notice] cjson using \"${COMPILE_TYPE}\" End make install"

        cd ${LOCAL_DIR}
        if [ -d ${SOURCE_CODE_PATH} ]; then
            rm -rf ${SOURCE_CODE_PATH}
        fi
        mkdir $SOURCE_CODE_PATH
        tar -zxf $TAR_FILE_NAME -C $SOURCE_CODE_PATH --strip-components 1
        cd ${LOCAL_DIR}/$SOURCE_CODE_PATH
        patch -p1 < ../CVE-2024-31755.patch
        patch -p1 < ../issue_IASWHC.patch
        patch -p1 < ../CVE-2023-53154.patch

        log "[Notice] cjson build using \"${COMPILE_TYPE}\" has been finished" 
    done    
}
