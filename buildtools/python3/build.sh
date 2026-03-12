#!/bin/bash
#######################################################################
# Copyright (c): 2012-2021, Huawei Tech. Co., Ltd.
# description: the script that make install bcrypt
# version: 3.7.4
# date: 2020-01-21
# history:
#######################################################################
set -e

# Use for Plpython3u
PLATFORM=$(sh $(pwd)/../../build/get_PlatForm_str.sh)

SSL_PATH=$(pwd)/../../output/kernel/dependency/openssl/comm/
if [ ! -d  $SSL_PATH ]; then
    echo "Openssl in output dir is not exist. Please build openssl first."
    exit 0
fi

TARGET_PATH=$(pwd)/../../output/kernel/platform/python3.7/

tar -xf ./Python-3.7.4.tar.xz
#add patch
cp ./00102-lib64.patch Python-3.7.4/
cp ./python3.7_ssl.patch Python-3.7.4/
cd Python-3.7.4/
patch -p1 < ./00102-lib64.patch
patch -p1 < ./python3.7_ssl.patch

#replace ssl path by openssl in output
sed -i "s#/usr/local/ssl#${SSL_PATH}#" ./Modules/Setup.dist
rm -rf $(pwd)/build_py37
mkdir $(pwd)/build_py37

export LD_LIBRARY_PATH=${SSL_PATH}/lib:$LD_LIBRARY_PATH

#compile python3
./configure --enable-shared CFLAGS='-fPIC -fstack-protector-strong -g -O2 -Wl,-z,relro,-z,now,-z,noexecstack' LDFLAGS='-Wl,-z,relro,-z,now' \
    --prefix=$(pwd)/build_py37 \
    --with-openssl=${SSL_PATH} --with-ssl-default-suites=openssl
make -j
make install -j

rm -rf ${TARGET_PATH}
mkdir -p ${TARGET_PATH}

cp -r $(pwd)/build_py37/* ${TARGET_PATH}

# remove symbol
objcopy --strip-all ${TARGET_PATH}lib/libpython3.7m.so.1.0 ${TARGET_PATH}lib/libpython3.7m.so.1.0_release
rm -f ${TARGET_PATH}lib/libpython3.7m.so.1.0
mv ${TARGET_PATH}lib/libpython3.7m.so.1.0_release ${TARGET_PATH}lib/libpython3.7m.so.1.0

# the Python3.7.4 uses also lib and lib64, we copy them to be the same.
cp -r ${TARGET_PATH}lib/* ${TARGET_PATH}/lib64
rm -rf ${TARGET_PATH}lib

PWD=$(pwd)
cd ${TARGET_PATH}
ln -s ./lib64 ./lib
cd ${PWD}

echo "End build python3."
