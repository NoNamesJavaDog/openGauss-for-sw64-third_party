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
# clean component 
#######################################################################
function clean_component()
{
	cd ${LOCAL_DIR}
	if [ $? -ne 0 ]; then
        die "[Error] cd ${LOCAL_DIR} failed."
    fi
    [ -n "install_comm_dist" ] && rm -rf "install_comm_dist"
    [ -n "install_llt_dist" ] && rm -rf "install_llt_dist"
    [ -n "${SOURCE_CODE_PATH}" ] && rm -rf ${SOURCE_CODE_PATH}
    [ -n "${SOURCE_CODE_PATH}.log" ] && rm -rf ${SOURCE_CODE_PATH}.log
    [ -n "${SOURCE_CODE_PATH}" ] && rm -rf ${SOURCE_CODE_PATH}
}

#######################################################################
# build .so and dist
#######################################################################
function build_dist_so()
{
	#build first
	ls $pwd
	echo "build_component first"
	build_component
	echo "build_component end"

	cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
	make
	if [ $? -ne 0 ]; then
			die "hll make failed"
	fi
	# shark
	mkdir -p ${LOCAL_DIR}/install_comm_dist
	mkdir -p ${LOCAL_DIR}/install_comm_dist/lib
	cp ${LOCAL_DIR}/postgresql-hll-2.14/*.so  ${LOCAL_DIR}/install_comm_dist/lib -r
        mkdir -p ${LOCAL_DIR}/install_comm_dist/include
        cp ${LOCAL_DIR}/postgresql-hll-2.14/hll.h ${LOCAL_DIR}/install_comm_dist/include
        cp ${LOCAL_DIR}/postgresql-hll-2.14/MurmurHash3.h ${LOCAL_DIR}/install_comm_dist/include
	if [ $? -ne 0 ]; then
			die "cp comm failed."
	fi
	mkdir -p ${LOCAL_DIR}/install_llt_dist
	mkdir -p ${LOCAL_DIR}/install_llt_dist/lib
	cp ${LOCAL_DIR}/postgresql-hll-2.14/*.so  ${LOCAL_DIR}/install_llt_dist/lib -r
        mkdir -p ${LOCAL_DIR}/install_llt_dist/include
        cp ${LOCAL_DIR}/postgresql-hll-2.14/hll.h ${LOCAL_DIR}/install_llt_dist/include
        cp ${LOCAL_DIR}/postgresql-hll-2.14/MurmurHash3.h ${LOCAL_DIR}/install_llt_dist/include
	if [ $? -ne 0 ]; then
			die "cp llt failed."
	fi

	# dist
	if [ ! -d "${INSTALL_COMPONENT_PATH_NAME}/comm" ];then
			die "[Error] Not found \"${INSTALL_COMPONENT_PATH_NAME}/comm/lib/libhll.so\". Please git pull. failed."
	else
			cp -r ${LOCAL_DIR}/install_comm_dist/* ${INSTALL_COMPONENT_PATH_NAME}/comm
	fi
	if [ ! -d "${INSTALL_COMPONENT_PATH_NAME}/llt" ];then
			die "[Error] Not found \"${INSTALL_COMPONENT_PATH_NAME}/llt/lib/libhll.so\". Please git pull. failed."
	else
			cp -r ${LOCAL_DIR}/install_llt_dist/* ${INSTALL_COMPONENT_PATH_NAME}/llt
	fi
	if [ $? -ne 0 ]; then
			die "[Error] \"cp libhll.so\" failed."
	fi
}
