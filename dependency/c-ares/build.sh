#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2010-2018. All rights reserved.
# description: the script that make install protobuf
set -e
python $(pwd)/../../build/pull_open_source.py "c-ares" "c-ares-1.15.0.tar.gz" "05833HTP"
######################################################################
# Parameter setting
######################################################################
LOCAL_PATH=${0}
FIRST_CHAR=$(expr substr "$LOCAL_PATH" 1 1)
if [ "$FIRST_CHAR" = "/" ]; then
    LOCAL_PATH=${0}
else
    LOCAL_PATH="$(pwd)/${LOCAL_PATH}"
fi

LOCAL_DIR=$(dirname "${LOCAL_PATH}")


BUILD_OPTION=release

tmp_cpus=$(grep -w processor /proc/cpuinfo|wc -l)

#######################################################################
## print help information
#######################################################################
function print_help()
{
        echo "Usage: $0 [OPTION]
        -h|--help               show help information
        -m|--build_option       provode type of operation, values of paramenter is build, shrink, dist or clean
    "
}

########################################################################
if [ $# = 0 ] ; then
        print_help
        exit 1
fi

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
#            shrink_component
#            dist_component
#            clean_component
            ;;
        *)
            echo "please input right paramenter values build, shrink, dist or clean "
    esac
}

function clean_component()
{
    rm c-ares-1.15.0 install -rf
    echo '-----It is clean!-------'
}

function build_component()
{
    echo '---------Start build-----------------'
    tar xzvf c-ares-1.15.0.tar.gz
    cp /usr/share/automake-1.16/config.guess c-ares-1.15.0/config.guess
    cp /usr/share/automake-1.16/config.sub c-ares-1.15.0/config.sub
    cd c-ares-1.15.0
	patch -p1 < ../c-ares-CVE-2020-8277.patch
    ./configure --prefix=${LOCAL_DIR}/install_comm CFLAGS=-fPIC
    make -j${tmp_cpus}
    make install
    echo '--------------End--------------------'
}

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
            BUILD_OPTION=$2
            shift 2
            ;;
        *)
            echo "./build.sh --help or ./build.sh -h"
            exit 1
    esac
done

###########################################################################

main
