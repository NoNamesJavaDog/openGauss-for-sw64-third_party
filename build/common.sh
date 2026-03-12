#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2010-2020. All rights reserved.
# description: the script provides common function
set -e
export BUILD_SCRIPT_PATH=$(cd "$(dirname "$0")";pwd)
export OPEN_SOURCE=$(dirname $BUILD_SCRIPT_PATH)
function logerr()
{
        echo "[ERROR] $@" 1>&2
}
function logwarn()
{
        echo "[WARNING] $@" 1>&2
}
function check_ret()
{
        if [ $? -ne 0 ]; then
                logerr "$@"
                exit 1
        fi
}
function loginfo()
{
        echo "[INFO] $@" 1>&2
}
function date_str()
{
        printf "$(date +'%Y-%m-%d %H:%M:%S')"
}
function logbuild()
{
        length_of_line=30
        printf "[BUILD] $1 ";
        for ((i=${#1};i<$length_of_line;i++)); do
                printf '.';
        done
        printf " ";
}
function build_item_sh()
{
        cd ${OPEN_SOURCE}
        errexit_old_val=$(set -o | grep errexit | awk '{print $2}')
        set +e
        logbuild $1
        cd $1
        start_tm=$(date +%s%N)
        if [ "$1" == "six" ]; then
                echo "build six"
                bash build.sh -m all > $BUILD_SCRIPT_PATH/${1}_build.log 2>&1
                build_result=$?
        elif [ "$1" == "test" ]; then
		echo "build test"
		build_result=$?
	else
        	grep "build_option" build.sh > /dev/null 2>&1
         	if [ $? -eq 0 ]; then
                	bash build.sh -m all > $BUILD_SCRIPT_PATH/${1}_build.log 2>&1
                	build_result=$?
        	else
                	bash build.sh  > $BUILD_SCRIPT_PATH/${1}_build.log 2>&1
                	build_result=$?
        	fi
        fi
        end_tm=$(date +%s%N)
        use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
	if [ $build_result -eq 0 ]; then
                printf "OK [%7ss]\n" "${use_tm}"
		state="Success"
		printf "%-12s build time:   %5s seconds   %s\n" $1 $use_tm $state>> $BUILD_SCRIPT_PATH/component_build_time.log
        else
                printf "FAILED [%7ss]\n" "${use_tm}"
		state="Failure"
                printf "%-12s build time:   %5s seconds   %s\n" $1 $use_tm $state>> $BUILD_SCRIPT_PATH/component_build_time.log
		exit 1
        fi
        if [ "$errexit_old_val" == "on" ]; then
                set -e
        fi
}
function build_item_py()
{
        cd ${OPEN_SOURCE}
        errexit_old_val=$(set -o | grep errexit | awk '{print $2}')
        set +e
        logbuild $1
        cd $1
        start_tm=$(date +%s%N)
        if [ "$1" == "six" ]; then
                echo "build six"
                build_result=$?
        elif [ "$1" == "test" ]; then
		echo "build test"
		build_result=$?
	else
        	grep "build mode" build.py > /dev/null 2>&1
        	if [ $? -eq 0 ]; then
        	        tar_name=$(ls |grep zip)
        	        if [ ! $tar_name ]; then
        	                tar_name=$(ls |grep tar.gz)
        	        fi
        	        if [ ! $tar_name ]; then
        	                tar_name=$(ls |grep rpm)
        	        fi
        	        python build.py -m all -f $tar_name -t "comm|llt" > $BUILD_SCRIPT_PATH/${1}_build.log 2>&1
        	        build_result=$?
        	else
        	        python build.py  > $BUILD_SCRIPT_PATH/${1}_build.log 2>&1
        	        build_result=$?
        	fi
	fi
        end_tm=$(date +%s%N)
        use_tm=$(echo $end_tm $start_tm | awk '{ print ($1 - $2) / 1000000000}' | xargs printf "%.2f")
        printf "%-12s build time:   %7s seconds\n" $1 $use_tm >> $BUILD_SCRIPT_PATH/component_build_time.log
        if [ $build_result -eq 0 ]; then
                printf "OK [%7ss]\n" "${use_tm}"
        	state="Success"
                printf "%-12s build time:   %5s seconds   %s\n" $1 $use_tm $state>> $BUILD_SCRIPT_PATH/component_build_time.log
	else
                printf "FAILED [%7ss]\n" "${use_tm}"
		state="Failure"
                printf "%-12s build time:   %5s seconds   %s\n" $1 $use_tm $state>> $BUILD_SCRIPT_PATH/component_build_time.log
                exit 1
        fi
        if [ "$errexit_old_val" == "on" ]; then
                set -e
        fi
}

