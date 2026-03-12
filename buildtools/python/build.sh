#!/bin/bash
#######################################################################
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
# description: the script that make install bcrypt
# version: 3.1.7
# date:
# history:
#######################################################################
set -e

PLATFORM=$(sh $(pwd)/../../build/get_PlatForm_str.sh)
export SSL_PATH=$(pwd)/../../dependency/openssl/install/comm/lib
export LD_LIBRARY_PATH=${SSL_PATH}:${LD_LIBRARY_PATH}
if [ ${PLATFORM} == "euleros2.0_sp5_x86_64" ]; then
    PYTHON_SOURCE=Python-2.7.5
else
    unzip -o python_2.7.16_src.zip
    mv ./python_2.7.16_src/Python-2.7.16.tgz ./
    PYTHON_SOURCE=Python-2.7.16
fi

mkdir -p $(pwd)/ucs2
tar zxvf ${PYTHON_SOURCE}.tgz -C ./ucs2
cp openssl.patch ./ucs2/${PYTHON_SOURCE}/Modules/
cd ./ucs2/${PYTHON_SOURCE}/Modules/
patch  -p0 < openssl.patch
cd ../
./configure --enable-unicode=ucs2 --prefix=$(pwd)/../../ucs2/build
make
make install
#make distclean

cd ../../
mkdir -p $(pwd)/ucs4
tar zxvf ${PYTHON_SOURCE}.tgz -C ./ucs4
cp openssl.patch ./ucs4/${PYTHON_SOURCE}/Modules/
cd ./ucs4/${PYTHON_SOURCE}/Modules/
patch  -p0 < openssl.patch
cd ../
./configure --enable-unicode=ucs4 --prefix=$(pwd)/../../ucs4/build 
make 
make install
#make distclean

cd ../../
SETUPTOOLS_SOURCE=setuptools-44.1.0
unzip -o ${SETUPTOOLS_SOURCE}.zip -d ./ucs2/
cd ./ucs2/${SETUPTOOLS_SOURCE}
./../build/bin/python setup.py build
./../build/bin/python setup.py install

cd ../../
SETUPTOOLS_SOURCE=setuptools-44.1.0
unzip -o ${SETUPTOOLS_SOURCE}.zip -d ./ucs4/
cd ./ucs4/${SETUPTOOLS_SOURCE}
./../build/bin/python setup.py build
./../build/bin/python setup.py install
