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
# choose the real files 
#######################################################################
function shrink_component()
{
	for COMPILE_TYPE in ${COMPLIE_TYPE_LIST}
	do
            case "${COMPILE_TYPE}" in
                	comm)
                                mkdir -p ${LOCAL_DIR}/install_comm_dist
                                mkdir -p ${LOCAL_DIR}/install_comm_dist/lib
                                cp ${LOCAL_DIR}/${SOURCE_CODE_PATH}/*.so  ${LOCAL_DIR}/install_comm_dist/lib -r
                                if [ $? -ne 0 ]; then
                                        die "[Error] \"cp -r ${LOCAL_DIR}/${SOURCE_CODE_PATH}/*.so ${LOCAL_DIR}/install_comm_dist\" failed."
                                fi
				;;
                        release)
                                ;;
                        debug)
                                ;;
                	llt)
                                mkdir -p ${LOCAL_DIR}/install_llt_dist
                                mkdir -p ${LOCAL_DIR}/install_llt_dist/lib
                                cp ${LOCAL_DIR}/${SOURCE_CODE_PATH}/*.so  ${LOCAL_DIR}/install_llt_dist/lib -r
                                if [ $? -ne 0 ]; then
                                        die "[Error] \"cp -r {LOCAL_DIR}/${SOURCE_CODE_PATH}/lib/* ${LOCAL_DIR}/install_llt_dist/lib\" failed."
                                fi
                       		;;
			release_llt)
				;;
			debug_llt)
				;;
                	*)
        	esac
		log "[Notice] libtinfo shrink using \"${COMPILE_TYPE}\" has been finished!"
	done
}

##############################################################################################################
# dist the real files to the matched path
#	we could makesure that $INSTALL_COMPNOENT_PATH_NAME is not null, '.' or '/'
##############################################################################################################
function dist_component()
{
	for COMPILE_TYPE in ${COMPLIE_TYPE_LIST}
	do
            case "${COMPILE_TYPE}" in
                	comm)
                                rm -rf ${INSTALL_COMPONENT_PATH_NAME}/comm/*
                                mkdir -p ${INSTALL_COMPONENT_PATH_NAME}
                                mkdir -p ${INSTALL_COMPONENT_PATH_NAME}/comm
                                mkdir -p ${INSTALL_COMPONENT_PATH_NAME}/comm/lib
                                cp -r ${LOCAL_DIR}/install_comm_dist/lib/* ${INSTALL_COMPONENT_PATH_NAME}/comm/lib
                                if [ $? -ne 0 ]; then
                                        die "[Error] \"cp -r ${LOCAL_DIR}/install_comm_dist/lib/* ${INSTALL_COMPONENT_PATH_NAME}/comm\" failed."
                                fi
	                	;;
			release)
				;;
			debug)
				;;
                	llt)
                                rm -rf ${INSTALL_COMPONENT_PATH_NAME}/llt/*
				mkdir -p ${INSTALL_COMPONENT_PATH_NAME}/llt
				mkdir -p ${INSTALL_COMPONENT_PATH_NAME}/llt/lib
                                cp -r ${LOCAL_DIR}/install_llt_dist/lib/* ${INSTALL_COMPONENT_PATH_NAME}/llt/lib
                                if [ $? -ne 0 ]; then
                                        die "[Error] \"cp -r ${LOCAL_DIR}/install_llt_dist/lib/* ${INSTALL_COMPONENT_PATH_NAME}/llt\" failed."
                                fi
                       		;;
			release_llt)
				;;
			debug_llt)
				;;
                	*)
        	esac
		log "[Notice] hll dist using \"${COMPILE_TYPE}\" has been finished!"
	done
}
