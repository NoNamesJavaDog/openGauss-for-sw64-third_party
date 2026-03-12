#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
#  description: the script that make install zlib
#  date: 2015-8-20
#  version: 1.0
#  history:
#    2015-12-19 update to zlib1.2.8
#    2017-04-21 update to zlib1.2.11

#######################################################################
# build and install component
#######################################################################
set -e

WORK_PATH="$(dirname $0)"

source "${WORK_PATH}/build_component_configure.sh"

function build_component()
{
    cd ${LOCAL_DIR}

    if [ -d ${SOURCE_CODE_PATH} ]; then
        rm -rf ${SOURCE_CODE_PATH}
    fi
    mkdir ${SOURCE_CODE_PATH}
    tar -xf $TAR_FILE_NAME -C $SOURCE_CODE_PATH --strip-components 1

    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
    if [ $? -ne 0 ]; then
        die "[Error] change dir to $SRC_DIR failed."
    fi
    patch -p1 < ../zlib.patch
    patch -p1 < ../zlib-CVE-2022-37434.patch
    patch -p1 < ../CVE-2023-45853.patch
    chmod +x configure        
    for COMPILE_TYPE in ${COMPLIE_TYPE_LIST}
    do
        log "[Notice] zlib Begin configure..."

        build_component_configure
 
        if [ $? -ne 0 ]; then
            die "zlib make failed."
        fi
        log "[Notice] zlib End make" 

        log "[Notice] zlib using \"${COMPILE_TYPE}\" Begin make install" 
        make install
        if [ $? -ne 0 ]; then
                    die "[Error] zlib make install failed."
                fi
        log "[Notice] zlib using \"${COMPILE_TYPE}\" End make install" 

        ######### make libminiunz ########
        log "[Notice] make and install libminiunz before zlib clean " 

        log "[Notice] enter contrib/minizip/" 
        cd contrib/minizip/


        log "[Notice] make libminiunz" 
        make CFLAGS="-O3 -fPIC -I../.." -f Makefile
        if [ $? -ne 0 ]; then
            die "failed to make libminiunz."
        fi

        ######### make install libminiunz ########
        log "[Notice] make install libminiunz" 
        mv libminiz.a libminiunz.a
        cp ioapi.h ${LOCAL_DIR}/install_${COMPILE_TYPE}/include/
        cp unzip.h ${LOCAL_DIR}/install_${COMPILE_TYPE}/include/
        cp libminiunz.a ${LOCAL_DIR}/install_${COMPILE_TYPE}/lib/
        chmod 644 ${LOCAL_DIR}/install_${COMPILE_TYPE}/include/ioapi.h ${LOCAL_DIR}/install_${COMPILE_TYPE}/include/unzip.h ${LOCAL_DIR}/install_${COMPILE_TYPE}/lib/libminiunz.a
        if [ $? -ne 0 ]; then
            die "[Error] libminiunz make install failed."
        fi

        ######### make install libminiunz ########
        log "[Notice] make clean libminiunz" 
        make clean -f Makefile
        log "[Notice] exit contrib/minizip/" 
        cd ../..

        make clean
        log "[Notice] zlib build using \"${COMPILE_TYPE}\" has been finished" 
    done    
}
