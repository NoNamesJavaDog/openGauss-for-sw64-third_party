#!/bin/bash
# copyright (c) Huawei Technologies Co., Ltd. 2010-2018. All rights reserved.
# description: the script that make install boost
# date: 2019-12-27
# version: 1.72.0
# history: fix buildcheck warning

set -e
#######################################################################
# build and install component
#######################################################################
function build_component()
{
    cd ${LOCAL_DIR}
    if [ -d ${SOURCE_CODE_PATH} ]; then
        rm -rf ${SOURCE_CODE_PATH}
    fi
    mkdir ${SOURCE_CODE_PATH}
    tar -zxf $TAR_FILE_NAME -C $SOURCE_CODE_PATH --strip-components 1
    cd ${LOCAL_DIR}/${SOURCE_CODE_PATH}
    if [ $? -ne 0 ]; then
        die "[Error] change dir to $SRC_DIR failed."
    fi

    # Compatible with python3 compilation
    python_version=`python3 -V | awk -F ' ' '{print $2}' |awk -F '.' -v OFS='.' '{print $1,$2}'`

    chmod +x bootstrap.sh
    chmod +x ./tools/build/src/engine/build.sh
    for COMPILE_TYPE in ${COMPLIE_TYPE_LIST}
    do
        log "[Notice] boost Begin configure..."
        case "${COMPILE_TYPE}" in
            release)
                die "[Error] boost not supported build type."
                ;;
            debug)
                die "[Error] boost not supported build type."
                ;;
            release_llt)
                die "[Error] boost not supported build type."
                ;;
            debug_llt)
                die "[Error] boost not supported build type."
                ;;
            comm|llt)
                mkdir -p ${LOCAL_DIR}/install_${COMPILE_TYPE}
                log "[Notice] boost configure string: ./bootstrap.sh --prefix=${LOCAL_DIR}/install_${COMPILE_TYPE}"
                ./bootstrap.sh --prefix=${LOCAL_DIR}/install_${COMPILE_TYPE}
                ./tools/build/src/engine/b2 cflags='-fPIC -D_GLIBCXX_USE_CXX11_ABI=0' cxxflags='-fPIC -D_GLIBCXX_USE_CXX11_ABI=0'
                if [ $? -ne 0 ]; then
                    die "[Error] boost configure failed."
                fi
                log "[Notice] boost End configure"

                if [ "${COMPILE_TYPE}"X = "comm"X ]; then
                    log "[Notice] boost using \"${COMPILE_TYPE}\" Begin make"
                    ./b2
                    log "[Notice] boost End make"
                    log "[Notice] boost using \"${COMPILE_TYPE}\" Begin make install"
                    ./b2 install
                    log "[Notice] boost using \"${COMPILE_TYPE}\" End make install"
                else
                    log "[Notice] boost using \"${COMPILE_TYPE}\" Start pic build"
                    chmod +x ${LOCAL_DIR}/pic_build.sh
                    cd ${LOCAL_DIR}
                    sh pic_build.sh
                    if [ $? -ne 0 ]; then
                        die "[Error] boost pic build failed."
                    fi
                    log "[Notice] boost using \"${COMPILE_TYPE}\" End pic build"
                fi
                ;;
            *)
                log "Internal Error: option processing error: $1"
                log "please write right paramenter in ${CONFIG_FILE_NAME}"
                exit 1
        esac
    done
}
