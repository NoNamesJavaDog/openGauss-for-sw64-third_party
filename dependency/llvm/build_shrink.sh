#!/bin/bash
# Perform PL/Java lib installation.
# Copyright (c) Huawei Technologies Co., Ltd. 2010-2018. All rights reserved.
# description: the script that make install pljava libs
# date: 2019-5-16
# modified:
# version: 1.0
# history:
WORK_PATH="$(dirname ${0})"
source "${WORK_PATH}/build_global.sh"
#######################################################################
# choose the real files
#######################################################################
function shrink_component()
{
    for COMPILE_TYPE in ${COMPILE_TYPE_LIST}
    do
        case "${COMPILE_TYPE}" in
            comm|llt|sanitizer)
                # copy only LLVM libs
                mkdir -p ${LOCAL_DIR}/install_comm_dist
                mkdir -p ${LOCAL_DIR}/install_comm_dist/bin
                cp ${LOCAL_DIR}/install_comm/include            ${LOCAL_DIR}/install_comm_dist/ -r
                cp ${LOCAL_DIR}/install_comm/lib                ${LOCAL_DIR}/install_comm_dist/ -r
                cp ${LOCAL_DIR}/install_comm/bin/llvm-config    ${LOCAL_DIR}/install_comm_dist/bin/
                rm -rf ${LOCAL_DIR}/install_comm_dist/lib/*so*
                ;;
            tool)
                # copy clang tools (and requried libraries)
                mkdir -p ${LOCAL_DIR}/install_tool_dist
                cp -r ${LOCAL_DIR}/install_tool/include            ${LOCAL_DIR}/install_tool_dist/
                cp -r ${LOCAL_DIR}/install_tool/bin                ${LOCAL_DIR}/install_tool_dist/
                cp -r ${LOCAL_DIR}/install_tool/lib                ${LOCAL_DIR}/install_tool_dist/
                cp -r ${LOCAL_DIR}/install_tool/libexec            ${LOCAL_DIR}/install_tool_dist/
                cp -r ${LOCAL_DIR}/install_tool/share              ${LOCAL_DIR}/install_tool_dist/
                # add more llvm tools
                cp ${LOCAL_DIR}/install_comm/bin/llvm-ar        ${LOCAL_DIR}/install_tool_dist/bin/
                cp ${LOCAL_DIR}/install_comm/bin/llvm-as        ${LOCAL_DIR}/install_tool_dist/bin/
                cp ${LOCAL_DIR}/install_comm/bin/llvm-dis       ${LOCAL_DIR}/install_tool_dist/bin/
                ;;
            *)
                die "[Error] unknown COMPILE_TYPE: ${COMPILE_TYPE}"
                ;;
        esac
        log "[Notice] llvm shrink using \"${COMPILE_TYPE}\" has been finished!"
    done
}

##############################################################################################################
# dist the real files to the matched path
# we could makesure that $INSTALL_COMPNOENT_PATH_NAME is not null, '.' or '/'
##############################################################################################################
function dist_component()
{
    for COMPILE_TYPE in ${COMPILE_TYPE_LIST}
    do
        case "${COMPILE_TYPE}" in
            comm|llt)
                rm -rf ${INSTALL_COMPONENT_PATH_NAME}/comm
                mkdir -p ${INSTALL_COMPONENT_PATH_NAME}/comm
                cp -r ${LOCAL_DIR}/install_comm_dist/* ${INSTALL_COMPONENT_PATH_NAME}/comm
                if [ $? -ne 0 ]; then
                    die "[Error] \"cp -r ${LOCAL_DIR}/install_comm_dist/* ${INSTALL_COMPONENT_PATH_NAME}/comm\" failed."
                fi
                ;;
            sanitizer)
                rm -rf ${INSTALL_COMPONENT_PATH_NAME}/memcheck
                mkdir -p ${INSTALL_COMPONENT_PATH_NAME}/memcheck
                cp -r ${LOCAL_DIR}/install_comm_dist/* ${INSTALL_COMPONENT_PATH_NAME}/memcheck
                if [ $? -ne 0 ]; then
                    die "[Error] \"cp -r ${LOCAL_DIR}/install_comm_dist/* ${INSTALL_COMPONENT_PATH_NAME}/memcheck\" failed."
                fi
                ;;
            tool)
                rm -rf ${INSTALL_COMPONENT_PATH_NAME}/tool
                mkdir -p ${INSTALL_COMPONENT_PATH_NAME}/tool
                cp -r ${LOCAL_DIR}/install_tool_dist/* ${INSTALL_COMPONENT_PATH_NAME}/tool
                if [ $? -ne 0 ]; then
                    die "[Error] \"cp -r ${LOCAL_DIR}/install_tool_dist/* ${INSTALL_COMPONENT_PATH_NAME}/tool\" failed."
                fi
                ;;
            *)
                die "[Error] unknown COMPILE_TYPE: ${COMPILE_TYPE}"
                ;;
        esac
        log "[Notice] llvm dist using \"${COMPILE_TYPE}\" has been finished!"
    done
}
