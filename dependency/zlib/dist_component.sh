#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
#  description: the script that make install zlib
#  date: 2015-8-20
#  version: 1.0
#  history:
#    2015-12-19 update to zlib1.2.8
#    2017-04-21 update to zlib1.2.11

##############################################################################################################
# dist the real files to the matched path
#    we could makesure that $INSTALL_COMPOENT_PATH_NAME is not null, '.' or '/'
##############################################################################################################
set -e
function dist_component()
{
    for COMPILE_TYPE in ${COMPLIE_TYPE_LIST}
    do
        case "${COMPILE_TYPE}" in
            comm)
                rm -rf ${INSTALL_COMPOENT_PATH_NAME}/comm/*
                mkdir -p ${INSTALL_COMPOENT_PATH_NAME}/comm
                cp -dr ${LOCAL_DIR}/install_comm_dist/* ${INSTALL_COMPOENT_PATH_NAME}/comm
                if [ $? -ne 0 ]; then
                    die "[Error] \"cp -r ${LOCAL_DIR}/install_comm_dist/* ${INSTALL_COMPOENT_PATH_NAME}/comm\" failed."
                fi
                ;;
            llt) 
                rm -rf ${INSTALL_COMPOENT_PATH_NAME}/llt/*
                mkdir -p ${INSTALL_COMPOENT_PATH_NAME}/llt
                cp -dr ${LOCAL_DIR}/install_llt_dist/* ${INSTALL_COMPOENT_PATH_NAME}/llt
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
        log "[Notice] zlib dist using \"${COMPILE_TYPE}\" has been finished!"
    done
}
