#!/bin/bash
# copyright (c) Huawei Technologies Co., Ltd. 2010-2018. All rights reserved.
# description: the script that make install boost
# date: 2020-11-20
# version: 1.72.0
# history: fix buildcheck warning

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
                mkdir -p ${LOCAL_DIR}/install_comm_dist
                cp -r ${LOCAL_DIR}/install_comm/* ${LOCAL_DIR}/install_comm_dist
                if [ $? -ne 0 ]; then
                    die "[Error] \"cp -r ${LOCAL_DIR}/install_comm/* ${LOCAL_DIR}/install_comm_dist\" failed."
                fi
                #rm -f ${LOCAL_DIR}/install_comm_dist/lib/*so*
                ;;
            llt)
                mkdir -p ${LOCAL_DIR}/install_llt_dist
                mkdir -p ${LOCAL_DIR}/install_llt_dist/lib
                mkdir -p ${LOCAL_DIR}/install_llt_dist/include
                cp ${LOCAL_DIR}/${SOURCE_CODE_PATH}/stage/lib/* ${LOCAL_DIR}/install_llt_dist/lib/
                if [ $? -ne 0 ]; then
                    die "[Error] \"cp ${LOCAL_DIR}/${SOURCE_CODE_PATH}/stage/lib/* ${LOCAL_DIR}/install_llt_dist/lib\" failed."
                fi

                cp -r ${LOCAL_DIR}/${SOURCE_CODE_PATH}/boost ${LOCAL_DIR}/install_llt_dist/include/
                if [ $? -ne 0 ]; then
                    die "[Error] \"cp -r ${LOCAL_DIR}/${SOURCE_CODE_PATH}/boost ${LOCAL_DIR}/install_llt_dist/include/\" failed."
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
        log "[Notice] boost shrink using \"${COMPILE_TYPE}\" has been finished!"
    done
}

