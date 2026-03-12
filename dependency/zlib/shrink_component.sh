#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
#  description: the script that make install zlib
#  date: 2015-8-20
#  version: 1.0
#  history:
#    2015-12-19 update to zlib1.2.8
#    2017-04-21 update to zlib1.2.11
#######################################################################
# choose the real files 
#######################################################################
set -e
function shrink_component()
{
    for COMPILE_TYPE in ${COMPLIE_TYPE_LIST}
    do
        case "${COMPILE_TYPE}" in
            release)
                ;;
            comm)
                mkdir ${LOCAL_DIR}/install_comm_dist
                cp -r ${LOCAL_DIR}/install_comm/* ${LOCAL_DIR}/install_comm_dist
                if [ $? -ne 0 ]; then
                        die "[Error] \"cp -r ${LOCAL_DIR}/install_comm/* ${LOCAL_DIR}/install_comm_dist\" failed."
                fi
                ;;
            llt)    
                mkdir ${LOCAL_DIR}/install_llt_dist
                cp -r ${LOCAL_DIR}/install_llt/* ${LOCAL_DIR}/install_llt_dist
                if [ $? -ne 0 ]; then
                    die "[Error] \"cp -r ${LOCAL_DIR}/install_llt/* ${LOCAL_DIR}/install_llt_dist\" failed."
                fi
                mv ${LOCAL_DIR}/install_llt_dist/lib/libz.so ${LOCAL_DIR}/install_llt_dist/lib/libz_pic.so    
                ;;
            debug)
                ;;
            release_llt)
                ;;
            debug_llt)
                ;;
            *)
        esac
        log "[Notice] zlib shrink using \"${COMPILE_TYPE}\" has been finished!"
    done
}
