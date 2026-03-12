#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
#  description: the script that make install zlib
#  date: 2015-8-20
#  version: 1.0
#  history:
#    2015-12-19 update to zlib1.2.8
#    2017-04-21 update to zlib1.2.11
set -e
function build_component_configure()
{

    case "${COMPILE_TYPE}" in
        release)
            die "[Error] zlib not supported build type."
            ;;
        debug)
            die "[Error] zlib not supported build type."
            ;;
        release_llt)
            die "[Error] zlib not supported build type."
            ;;
        debug_llt)
            die "[Error] zlib not supported build type."
            ;;
        comm|llt)
            CONFIGURE_EXTRA_FLAG="--64"
            if [[ X"$(uname -m)" == X*"aarch64" ]];then
                CONFIGURE_EXTRA_FLAG=""
            fi
            if [[ X"$(uname -m)" == X*"loongarch64" ]];then
                CONFIGURE_EXTRA_FLAG=""
            fi
            if [[ X"$(uname -m)" == X*"sw_64" ]];then
                CONFIGURE_EXTRA_FLAG=""
            fi
            mkdir -p ${LOCAL_DIR}/install_${COMPILE_TYPE}
            log "[Notice] zlib configure string: ./configure ${CONFIGURE_EXTRA_FLAG} --prefix=${LOCAL_DIR}/install_${COMPILE_TYPE}"
            ./configure ${CONFIGURE_EXTRA_FLAG} --prefix=${LOCAL_DIR}/install_${COMPILE_TYPE}
            sed -i '21a CFLAGS += -fPIC' Makefile

            if [ $? -ne 0 ]; then
                die "[Error] zlib configure failed."
            fi
            log "[Notice] zlib End configure"

            log "[Notice] zlib using \"${COMPILE_TYPE}\" Begin make"

            MAKE_EXTRA_FLAG="-m64"
            if [[ X"$(uname -m)" == X*"aarch64" ]];then
                MAKE_EXTRA_FLAG=""
            fi
            if [[ X"$(uname -m)" == X*"loongarch64" ]];then
                MAKE_EXTRA_FLAG=""
            fi
            if [[ X"$(uname -m)" == X*"sw_64" ]];then
                MAKE_EXTRA_FLAG=""
            fi
            MAKE_EXTRA_FLAG="$MAKE_EXTRA_FLAG -D_FORTIFY_SOURCE=2"
            if [ "${COMPILE_TYPE}"X = "comm"X ]; then
                make CFLAGS="-fPIE -fPIC" SFLAGS="-O2 -fPIC -fstack-protector-strong -Wl,-z,noexecstack -Wl,-z,relro,-z,now ${MAKE_EXTRA_FLAG} -D_LARGEFILE64_SOURCE=1 -DHAVE_HIDDEN" -j4
            else
                make CFLAGS="-O3 -fPIE -fPIC ${MAKE_EXTRA_FLAG} -D_LARGEFILE64_SOURCE=1 -DHAVE_HIDD" SFLAGS="-O3 -fPIC -fstack-protector-strong -Wl,-z,noexecstack -Wl,-z,relro,-z,now ${MAKE_EXTRA_FLAG} -D_LARGEFILE64_SOURCE=1 -DHAVE_HIDDEN" -j4
            fi     
                ;;
        *)
             log "Internal Error: option processing error: $1"   
            log "please write right paramenter in ${CONFIG_FILE_NAME}"
            exit 1
    esac
}
