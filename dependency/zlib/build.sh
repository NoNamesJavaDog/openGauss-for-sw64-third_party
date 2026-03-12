#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
#  description: the script that make install zlib
#  date: 2015-8-20
#  version: 1.0
#  history:
#    2015-12-19 update to zlib1.2.8
#    2017-04-21 update to zlib1.2.11

######################################################################
# Parameter setting
######################################################################
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
            log "please input right paramenter values build, shrink, dist or clean all"
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
