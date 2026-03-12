#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2010-2022. All rights reserved.
# description: the script that make install cjson
# date: 2020-08-10
# version: 2.0
# history:
# 2019-5-5 update to cjson 1.7.11 from 1.7.7
# 2019-12-28 fix buildcheck warning
# 2020-06-22 fix buildcheck warning
# 2020-08-10 update to cjson 1.7.13 from 1.7.11

set -e

#######################################################################
# choose the real files 
#######################################################################
function shrink_component()
{
    for COMPILE_TYPE in ${COMPLIE_TYPE_LIST}
    do
        case "${COMPILE_TYPE}" in
            release)
                ;;
            comm)
                mkdir -p ${LOCAL_DIR}/install_comm_dist/lib
                cp -dr ${LOCAL_DIR}/install_comm/include ${LOCAL_DIR}/install_comm_dist
                cp -a ${LOCAL_DIR}/install_comm/lib/*\.so* ${LOCAL_DIR}/install_comm_dist/lib
                if [ $? -ne 0 ]; then
                    die "[Error] \"cp -r ${LOCAL_DIR}/install_comm/* ${LOCAL_DIR}/install_comm_dist\" failed."
                fi
                ;;
            llt)
                mkdir -p ${LOCAL_DIR}/install_llt_dist/lib
                cp -dr ${LOCAL_DIR}/install_llt/include ${LOCAL_DIR}/install_llt_dist
                cp -a ${LOCAL_DIR}/install_llt/lib/*\.so* ${LOCAL_DIR}/install_llt_dist/lib
                if [ $? -ne 0 ]; then
                     die "[Error] \"cp -r ${LOCAL_DIR}/install_llt/* ${LOCAL_DIR}/install_llt_dist\" failed."
                fi
                ;;
            debug)
                ;;
            release_llt)
                ;;
            debug_llt)
                ;;
            *)
        esac
        log "[Notice] lz4 shrink using \"${COMPILE_TYPE}\" has been finished!"
    done
}
