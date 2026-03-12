#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
#sudo yum install -y libffi-devel
set -e
python $(pwd)/../../build/pull_open_source.py "cffi" "v1.17.1.tar.gz" "05833NKG"
PLATFORM=$(sh $(pwd)/../../build/get_PlatForm_str.sh)
mkdir -p $(pwd)/../../output/dependency/install_tools_$PLATFORM
export TARGET_PATH=$(pwd)/../../output/dependency/install_tools_$PLATFORM
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH:/usr/lib64
export PATH=$TARGET_PATH:$PATH
export PYTHONPATH=$TARGET_PATH:$LIBRARY_PATH
python_version=`python3 -V | awk -F ' ' '{print $2}' | awk -F '.' -v OFS='.' '{print $1,$2}'`
TAR_SOURCE_FILE=v1.17.1.tar.gz
SOURCE_FILE=cffi-1.17.1

cd ../
rm -rf $SOURCE_FILE
tar zxvf $TAR_SOURCE_FILE
cd $SOURCE_FILE
PYTHON_PATH=$(pwd)/../../../buildtools/python
${PYTHON_PATH}/ucs2/build/bin/python setup.py build
PYTHONHASHSEED=0 ${PYTHON_PATH}/ucs2/build/bin/python setup.py install
cp -r build/lib*/_cffi_backend.so $TARGET_PATH/_cffi_backend.so_UCS2_$python_version
