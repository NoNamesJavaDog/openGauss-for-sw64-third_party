#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2010-2018. All rights reserved.
# description: the script that make install libcurl
# date: 2020-11-16
# version: 7.71.0
# history:
# 2020-11-16 upgrade to curl-7.71.0.tar.gz

set -e

tmp_cpus=$(grep -w processor /proc/cpuinfo|wc -l)

TAR_FILE=curl-curl-7_78_0.tar.gz
SRC_DIR=curl

TRUNK_DIR=${PWD}/../../
THIRD_PARTY_BINARYLIBS=$THIRDPARTY_FOLDER

INSTALL_DIR="$TRUNK_DIR/output/kernel/dependency/libcurl/comm/"
INSTALL_DIR_LLT="$TRUNK_DIR/output/kernel/dependency/libcurl/llt/"
PREFIX_DIR="$TRUNK_DIR/dependency/libcurl/install_comm"
LOG_FILE="$TRUNK_DIR/dependency/libcurl/libcurl.log"

#######################################################################
#  Print log.
#######################################################################
log()
{
    printf "[Build libcurl] $(date +%y-%m-%d" "%T): $@"
    echo "[Build libcurl] $(date +%y-%m-%d" "%T): $@" >> "$LOG_FILE" 2>&1
}

print_done()
{
    echo "done"
}

#######################################################################
#  print log and exit.
#######################################################################
die()
{
    log "$@"
    echo "$@"
    echo "For more information, please see the log file: $LOG_FILE"
    exit $BUILD_FAILED
}

checkret()
{
    if [ $? -ne 0 ]
    then
        die "[Error] " $1
    fi
}

main()
{
    rm -f $LOG_FILE;
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TRUNK_DIR/output/kernel/dependency/openssl/comm/lib
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TRUNK_DIR/output/kernel/dependency/zlib1.2.11/comm/lib
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TRUNK_DIR/output/kernel/dependency/kerberos/comm/lib
    export C_INCLUDE_PATH=$C_INCLUDE_PATH:$TRUNK_DIR/output/kernel/dependency/kerberos/comm/include

    #set_gcc
    if [ -d ${SRC_DIR} ]; then
        rm -rf ${SRC_DIR}
    fi
    mkdir $SRC_DIR
    tar -zxf $TAR_FILE -C $SRC_DIR --strip-components 1
    checkret "Failed to unpackage the tar file: $TAR_FILE"
    cp /usr/share/automake-1.16/config.guess $SRC_DIR/config.guess
    cp /usr/share/automake-1.16/config.sub $SRC_DIR/config.sub

    cd $SRC_DIR

    log "[Info] patching ......... "
    patch -p1 < ../curl.patch >> $LOG_FILE 2>&1
    patch -p1 < ../1-CVE-2021-22945.patch >> $LOG_FILE 2>&1
    patch -p1 < ../2-CVE-2021-22946.patch >> $LOG_FILE 2>&1
    patch -p1 < ../3-CVE-2021-22947.patch >> $LOG_FILE 2>&1
    patch -p1 < ../4-CVE-2022-22576.patch >> $LOG_FILE 2>&1
    patch -p1 < ../5-CVE-2022-27775.patch >> $LOG_FILE 2>&1

    patch -p1 < ../6-CVE-2022-27776.patch >> $LOG_FILE 2>&1
    patch -p1 < ../7-CVE-2022-27776_2.patch >> $LOG_FILE 2>&1
    patch -p1 < ../8-CVE-2022-27776_3.patch >> $LOG_FILE 2>&1
    patch -p1 < ../9-CVE-2022-27774.patch >> $LOG_FILE 2>&1
    patch -p1 < ../10-CVE-2022-27774_2.patch >> $LOG_FILE 2>&1
    patch -p1 < ../11-CVE-2022-27774_3.patch >> $LOG_FILE 2>&1
    patch -p1 < ../12-CVE-2022-27774_4.patch >> $LOG_FILE 2>&1
    patch -p1 < ../13-CVE-2022-27781.patch >> $LOG_FILE 2>&1
    patch -p1 < ../14-CVE-2022-27782.patch >> $LOG_FILE 2>&1
    patch -p1 < ../15-CVE-2022-27782_2.patch >> $LOG_FILE 2>&1
    patch -p1 < ../16-CVE-2022-32208.patch >> $LOG_FILE 2>&1
    patch -p1 < ../17-CVE-2022-32207.patch >> $LOG_FILE 2>&1
    patch -p1 < ../18-CVE-2022-32207_2.patch >> $LOG_FILE 2>&1
    patch -p1 < ../19-CVE-2022-32207_3.patch >> $LOG_FILE 2>&1
    patch -p1 < ../20-CVE-2022-32206.patch >> $LOG_FILE 2>&1
    patch -p1 < ../21-CVE-2022-32206_2.patch >> $LOG_FILE 2>&1
    patch -p1 < ../22-CVE-2022-32205.patch >> $LOG_FILE 2>&1
    patch -p1 < ../23-CVE-2022-32205_2.patch >> $LOG_FILE 2>&1
    patch -p1 < ../24-CVE-2022-32205_3.patch >> $LOG_FILE 2>&1
    patch -p1 < ../0001-Backport-fix-CVE-2022-35252-curl-7.78.0.patch >> $LOG_FILE 2>&1
    patch -p1 < ../0002-Backport-fix-CVE-2022-35252-curl-7.78.0.patch >> $LOG_FILE 2>&1
    patch -p1 < ../25-CVE-2022-42916.patch >> $LOG_FILE 2>&1
    patch -p1 < ../26-CVE-2022-32221.patch >> $LOG_FILE 2>&1
    patch -p1 < ../27-CVE-2022-42915.patch >> $LOG_FILE 2>&1
    patch -p1 < ../cve-2022-43551.patch >> $LOG_FILE 2>&1
    patch -p1 < ../cve-2022-43552.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-23914-1.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-23914-3.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-23914-4.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-23914-5.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-23916-1.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-23916-2.patch >> $LOG_FILE 2>&1

    patch -p1 < ../CVE-2023-27533.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-27534-0.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-27534-1.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-27538.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-27535-1.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-27535-0.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-27536.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-28322.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-46218.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-38545.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2024-2398.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2024-7264.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2024-9681.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2024-11053.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2025-0167.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2025-0725.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2025-9086.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2023-38039.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2025-14017.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2025-14524.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2025-15079.patch >> $LOG_FILE 2>&1
    patch -p1 < ../CVE-2025-15224.patch >> $LOG_FILE 2>&1

    checkret "Failed to patch huawei_curl.patch"
    print_done

    ./buildconf
    chmod a+x configure

    log "[Info] configuring ...... "
    ./configure --prefix="$PREFIX_DIR" --disable-ldap --without-nghttp2 --with-ssl=$TRUNK_DIR/output/kernel/dependency/openssl/comm --without-libssh2 CFLAGS='-fstack-protector-strong -Wl,-z,relro,-z,now -D_FORTIFY_SOURCE=2 -O2' --with-zlib=$TRUNK_DIR/output/kernel/dependency/zlib1.2.11/comm --with-gssapi_krb5_gauss-includes=$TRUNK_DIR/output/kernel/dependency/kerberos/comm/include --with-gssapi_krb5_gauss-libs=$TRUNK_DIR/output/kernel/dependency/kerberos/comm/lib >> $LOG_FILE 2>&1
    checkret "Failed to configure libcurl."
    print_done
    
    log "[Info] making ... "
    make -j${tmp_cpus}   >> $LOG_FILE 2>&1
    log "[Info] making install ... "
    make install   >> $LOG_FILE 2>&1
    checkret "Failed to make install."
    print_done
   
    mkdir -p $INSTALL_DIR 
    cp -r $PREFIX_DIR/lib $INSTALL_DIR
    cp -r $PREFIX_DIR/include $INSTALL_DIR
    cd $INSTALL_DIR/lib
    rm -rf pkgconfig/
    rm libcurl.a libcurl.la
    cp -r $INSTALL_DIR $INSTALL_DIR_LLT
    
    log "[Info] Successfully installed libcurl into $INSTALL_DIR"
    echo ""
}

main
