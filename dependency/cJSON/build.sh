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

WORK_PATH="$(dirname $0)"

source "${WORK_PATH}/build_common.sh"

source "${WORK_PATH}/build_component.sh"

source "${WORK_PATH}/shrink_component.sh"

source "${WORK_PATH}/dist_component.sh"

source "${WORK_PATH}/clean_component.sh"

#######################################################################
#######################################################################
#######################################################################
# main
#######################################################################
#######################################################################
#######################################################################
function main()
{

    if [ -d ${SOURCE_CODE_PATH} ]; then
        rm -rf ${SOURCE_CODE_PATH}
    fi
    mkdir $SOURCE_CODE_PATH
    tar -zxf $TAR_FILE_NAME -C $SOURCE_CODE_PATH --strip-components 1
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
    patch -p1 < ../CVE-2024-31755.patch
    patch -p1 < ../issue_IASWHC.patch
    patch -p1 < ../CVE-2023-53154.patch
    patch -p1 < ../CVE-2025-57052.patch
    case "${BUILD_OPTION}" in
        build)
            build_component
            ;;
        shrink)
            shrink_component
            ;;
        dist)
            dist_component            
            ;;
        clean)
            clean_component    
            ;;
        all)
            build_component
            shrink_component
            dist_component
            clean_component
            ;;
        *)
            log "Internal Error: option processing error: $2"   
            log "please input right paramenter values build, shrink, dist or clean "
        esac
}


########################################################################
if [ $# = 0 ] ; then
        log "missing option"
        print_help
        exit 1
fi

##########################################################################
#read command line paramenters
##########################################################################
while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            print_help
            exit 1
            ;;
        -m|--build_option)
            if [ "$2"X = X ];then
                 die "no given version number values"
            fi
            BUILD_OPTION=$2
            shift 2
            ;;
        *)
            log "Internal Error: option processing error: $1" 1>&2
            log "please input right paramtenter, the following command may help you"
            log "./build.sh --help or ./build.sh -h"
            exit 1
    esac
done

###########################################################################
main
