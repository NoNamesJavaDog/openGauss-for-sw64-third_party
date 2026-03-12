#!/bin/bash
# Copyright © Huawei Technologies Co., Ltd. 2010-2019. All rights reserved.
#  description: the script that make install hll libs
#  date: 2019-7-16
#  modified: 
#  version: 1.0
#  history:

work_path=$(dirname $0)
echo $work_path
source $work_path/build_global.sh
#######################################################################
## print help information
#######################################################################
function print_help()
{
    echo "Usage: $0 [OPTION]
    -h|--help           show help information
    -m|--build_option   provide type of operation, values of paramenter is all, build, shrink, dist or clean
	"
}

#######################################################################
#  Print log.
#######################################################################
log()
{
    echo "[Build hll] $(date '+%y-%m-%d %T'): $@"
    echo "[Build hll] $(date '+%y-%m-%d %T'): $@"> "$LOG_FILE" 2>&1
}

#######################################################################
#  print log and exit.
#######################################################################
die()
{
    log "$@"
    echo "$@"
    exit $BUILD_FAILED
}

#######################################################################
# build and install component
#######################################################################
function build_component()
{
    cd ${LOCAL_DIR}
    [ -n "${SOURCE_CODE_PATH}" ] && rm -rf ${SOURCE_CODE_PATH}
    rm -f ${SOURCE_CODE_PATH}.log
    unzip ${ZIP_FILE_NAME} > /dev/null
    patch -s -p0< huawei_hll.patch 2>&1
    if [ $? -ne 0 ]; then
        die "[Error] change dir to $SRC_DIR failed."
    fi

	for COMPILE_TYPE in ${COMPLIE_TYPE_LIST}
	do
		case "${COMPILE_TYPE}" in
			release)
				die "[Error] hll not supported build type."
				;;
			debug)
				die "[Error] hll not supported build type."
				;;
			comm)
                		cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
                		make -sj all
				;;
			release_llt)
				die "[Error] hll not supported build type."
				;;
			debug_llt)
				die "[Error] hll not supported build type."
				;;
			llt)
                		cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
                		make -sj all
				;;
			 *)
				log "Internal Error: option processing error: $1"
				log "please write right paramenter in ${CONFIG_FILE_NAME}"
				exit 1
		esac

        if [ $? -ne 0 ]; then
                die "[Error] hll configure failed."
        fi

        make
        if [ $? -ne 0 ]; then
                die "hll make failed."
        fi

        if [ $? -ne 0 ]; then
                die "hll make install failed."
        fi
	done
}
