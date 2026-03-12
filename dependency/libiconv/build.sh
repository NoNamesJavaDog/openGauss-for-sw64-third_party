#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2010-2020. All rights reserved.
# description: the script that make install libiconv
# date: 2020-04-18
# version: 1.16
# history:
# 2020-01-04 import libiconv-1.15 into open_source
# 2020-04-18 update libiconv-1.15 to libiconv-1.16

set -e
ARCH=`uname -m`

iconv_dir=$(pwd)/libiconv-1.17/
build_dir=$(pwd)/install_comm
if [ -d ${iconv_dir} ]; then
    rm -rf ${iconv_dir}
fi
if [ -d ${build_dir} ]; then
    rm -rf ${build_dir}
fi

tar -zxvf $(pwd)/libiconv-1.17.tar.gz
cd $iconv_dir

patch -p1 < ../libiconv.patch

chmod 777 configure
if [[ "$ARCH"x = "loongarch64"x ]];then
    cp -rf $(pwd)/../../../build-aux/* ./build-aux/
    cp -rf $(pwd)/../../../build-aux/* ./libcharset/build-aux/
fi
if [[ "$ARCH"x = "sw_64"x ]];then
    cp /usr/share/automake-1.16/config.guess ./build-aux/config.guess
    cp /usr/share/automake-1.16/config.sub ./build-aux/config.sub
    cp /usr/share/automake-1.16/config.guess ./libcharset/build-aux/config.guess
    cp /usr/share/automake-1.16/config.sub ./libcharset/build-aux/config.sub
fi

./configure CFLAGS='-fPIC -fstack-protector-all --param ssp-buffer-size=4 -Wstack-protector' CPPFLAGS='-fPIC -fstack-protector-all --param ssp-buffer-size=4 -Wstack-protector' LDFLAGS='-Wl,-z,relro,-z,now' --prefix=$build_dir --disable-rpath

make clean
make -j4
make install
cd ..
cp -r install_comm install_llt
