#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2010-2018. All rights reserved.
# description: the script that make install pcre
# date: 2020-06-24
# version: 8.44
# history:
# 2020-01-04 import pcre-8.42 into open_source
# 2020-06-24 upgrade pcre-8.42 to pcre-8.44

set -e

tar -xf $(pwd)/pcre-8.45.tar.bz2
cp /usr/share/automake-1.16/config.guess pcre-8.45/config.guess
cp /usr/share/automake-1.16/config.sub pcre-8.45/config.sub
pcre_dir=$(pwd)/pcre-8.45/
build_dir=$(pwd)/install_comm

rm -rf install_*

cd ${pcre_dir}
patch -p1 < ../pcre.patch

chmod 777 configure
autoreconf -f -i

./configure CFLAGS='-fPIC -fstack-protector-all --param ssp-buffer-size=4 -Wstack-protector' CPPFLAGS='-fPIC -fstack-protector-all --param ssp-buffer-size=4 -Wstack-protector' LDFLAGS='-Wl,-z,relro,-z,now' --prefix=$build_dir --enable-utf --disable-rpath

make clean
make -j4
make install
cd ..
cp -r install_comm install_llt
