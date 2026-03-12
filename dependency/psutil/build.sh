#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
set -e
mkdir -p $(pwd)/../../output/install_tools
python_version=`python3 -V | awk -F ' ' '{print $2}' |awk -F '.' -v OFS='.' '{print $1,$2}'`
file_name=${python_version/./}m
export TARGET_PATH=$(pwd)/../../output/install_tools/
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH
TAR_SOURCE_FILE=release-6.0.0.tar.gz
SOURCE_FILE=psutil
if [ -d ${SOURCE_FILE} ]; then
    rm -rf ${SOURCE_FILE}
fi
mkdir ${SOURCE_FILE}
tar -zxf $TAR_SOURCE_FILE -C $SOURCE_FILE --strip-components 1
cd $SOURCE_FILE
CFLAGS='-fstack-protector-all' LDFLAGS='-Wl,-z,relro,-z,now -z,noexecstack' python3 setup.py build

python3 setup.py build
if [[ "$PLATFORM" == centos* ]]; then
    CPU_BIT=$(uname -m)
    if [ X"$CPU_BIT" = X"x86_64" ]; then
        gcc -pthread -shared -Wl,-z,relro,-z,now,-z,noexecstack -s -ftrapv -g build/temp.linux-x86_64-$python_version/psutil/_psutil_common.o build/temp.linux-x86_64-$python_version/psutil/_psutil_posix.o build/temp.linux-x86_64-$python_version/psutil/_psutil_linux.o  -o build/lib.linux-x86_64-$python_version/psutil/_psutil_linux.cpython-$file_name-x86_64-linux-gnu.so
        gcc -pthread -shared -Wl,-z,relro,-z,now,-z,noexecstack -s -ftrapv -g build/temp.linux-x86_64-$python_version/psutil/_psutil_common.o build/temp.linux-x86_64-$python_version/psutil/_psutil_posix.o  -o build/lib.linux-x86_64-$python_version/psutil/_psutil_posix.cpython-$file_name-x86_64-linux-gnu.so
    fi
fi
python3 setup.py install --user
cp -r build/lib*/* $TARGET_PATH
# add boost script
cp ../_psutil_linux.py $TARGET_PATH/psutil/
cp ../_psutil_posix.py $TARGET_PATH/psutil/

version_num=("3.6" "3.7" "3.8" "3.9" "3.10" "3.11")
for (( i=0;i<${#version_num[*]};i++ ))
do
    if [[ $(python3 -V | awk '{print $2}') =~ ${version_num[$i]} ]]; then
        mv $TARGET_PATH/psutil/_psutil_linux.*.so $TARGET_PATH/psutil/_psutil_linux.so_${version_num[$i]}
        mv $TARGET_PATH/psutil/_psutil_posix.*.so $TARGET_PATH/psutil/_psutil_posix.so_${version_num[$i]}
        if [ $? -ne 0 ]; then
             die "[Error] \"mv $TARGET_PATH/_psutil_linux.*.so $TARGET_PATH/psutil/_psutil_linux.so_${version_num[$i]}\" failed."
        fi
        break

    fi
done
