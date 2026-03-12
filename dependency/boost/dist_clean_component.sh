#!/bin/bash
# copyright (c) Huawei Technologies Co., Ltd. 2010-2018. All rights reserved.
# description: the script that make install boost
# date: 2019-12-27
# version: 1.72.0
# history: fix buildcheck warning

set -e

##############################################################################################################
# dist the real files to the matched path
#       we could makesure that $INSTALL_COMPOENT_PATH_NAME is not null, '.' or '/'
##############################################################################################################
function dist_component()
{
    for COMPILE_TYPE in ${COMPLIE_TYPE_LIST}
    do
        case "${COMPILE_TYPE}" in
            comm)
                if [ ! -d ${INSTALL_COMPOENT_PATH_NAME}/comm ]; then
                  mkdir -p ${INSTALL_COMPOENT_PATH_NAME}/comm/include && mkdir -p ${INSTALL_COMPOENT_PATH_NAME}/comm/lib
                fi
                #rm -rf ${INSTALL_COMPOENT_PATH_NAME}/comm/*
                cp -r ${LOCAL_DIR}/install_comm_dist/include ${INSTALL_COMPOENT_PATH_NAME}/comm
                cp ${LOCAL_DIR}/install_comm_dist/lib/libboost_atomic.a ${INSTALL_COMPOENT_PATH_NAME}/comm/lib/
                cp ${LOCAL_DIR}/install_comm_dist/lib/libboost_chrono.a ${INSTALL_COMPOENT_PATH_NAME}/comm/lib/
                cp ${LOCAL_DIR}/install_comm_dist/lib/libboost_system.a ${INSTALL_COMPOENT_PATH_NAME}/comm/lib/
                cp ${LOCAL_DIR}/install_comm_dist/lib/libboost_thread.a ${INSTALL_COMPOENT_PATH_NAME}/comm/lib/
                if [ $? -ne 0 ]; then
                    die "[Error] \"cp -r ${LOCAL_DIR}/install_comm_dist/* ${INSTALL_COMPOENT_PATH_NAME}/comm\" failed."
                fi
                ;;
            llt)
                if [ ! -d ${INSTALL_COMPOENT_PATH_NAME}/llt ]; then
                  mkdir -p ${INSTALL_COMPOENT_PATH_NAME}/llt
                fi
                rm -rf ${INSTALL_COMPOENT_PATH_NAME}/llt/*
                cp -r ${LOCAL_DIR}/install_llt_dist/* ${INSTALL_COMPOENT_PATH_NAME}/llt
                if [ $? -ne 0 ]; then
                    die "[Error] \"cp -r ${LOCAL_DIR}/install_llt_dist/* ${INSTALL_COMPOENT_PATH_NAME}/llt\" failed."
                fi
                ;;
            release)
                ;;
            debug)
                ;;
            release_llt)
                ;;
            debug_llt)
                ;;
            *)
        esac
        log "[Notice] boost dist using \"${COMPILE_TYPE}\" has been finished!"
    done
}

#######################################################################
# clean component
#######################################################################
function clean_component()
{
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
    if [ $? -ne 0 ]; then
        die "[Error] cd ${LOCAL_DIR}/${SOURCE_CODE_PATH} failed."
    fi

    cd ${LOCAL_DIR}
    if [ $? -ne 0 ]; then
        die "[Error] cd ${LOCAL_DIR} failed."
    fi
    [ -n "${SOURCE_CODE_PATH}" ] && rm -rf ${SOURCE_CODE_PATH}
    #rm -rf install_*

    log "[Notice] boost clean has been finished!"
}

