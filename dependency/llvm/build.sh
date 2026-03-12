#!/bin/bash
# Copyright © Huawei Technologies Co., Ltd. 2010-2019. All rights reserved.
# description: the script that make install llvm libs
# date: 2015-9-15
# modified: 2019-1-29
# version: 2.0
# history:
# modified:
set -e

package_name=llvm-project

WORK_PATH="$(dirname $0)"
source "${WORK_PATH}/build_global.sh"
source "${WORK_PATH}/build_component.sh"
source "${WORK_PATH}/build_shrink.sh"
#######################################################################
# main
#######################################################################

function main()
{
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

if [ $(uname -m) = "x86_64" ]; then
    BUILD_TARGET="X86"
elif [ $(uname -m) = "sw_64" ]; then
    BUILD_TARGET="Sw64"
elif [ $(uname -m) = "aarch64" ]; then
    BUILD_TARGET="AArch64"
fi

##########################################################################
#read command line paramenters
##########################################################################
while getopts "h:m:t:c:" opt
do
    case "$opt" in
    m)
        if [[ "$OPTARG"X = ""X ]];then
            die "no given version info"
        fi
        if [[ $# -lt 2 ]];then
            die "not enough params"
        fi
        BUILD_OPTION=$OPTARG
        ;;
    t)
        if [[ "$OPTARG"X != "X86"X ]] && [[ "$OPTARG"X != "AArch64"X ]];then
            die "not correct platform"
        fi
        if [[ $# -lt 2 ]];then
            die "not enough params"
        fi
        BUILD_TARGET=$OPTARG
        ;;
    c)
        if [[ "$OPTARG"X = ""X ]];then
            die "no given compile params e.g. -c comm/-c tool"
        fi
        if [[ $# -lt 2 ]];then
            die "not enough params"
        fi
        COMPILE_TYPE_LIST=$OPTARG 
        ;;
    *)
        log "Internal Error: option processing error: $1" 1>&2
        log "please input right paramtenter, the following command may help you"
        log "./build.sh"
        exit 1
    esac
done

###########################################################################
main
