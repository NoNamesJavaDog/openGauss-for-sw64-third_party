#######################################################################
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
# description: the script that make install pynacl
# version: 1.4.0
# date:
# history:
#######################################################################
set -e
ROOT_DIR=$(pwd)
mkdir -p $(pwd)/../../output/install_tools
ARCH=`uname -m`
python_version=`python3 -V | awk -F ' ' '{print $2}' |awk -F '.' -v OFS='.' '{print $1,$2}'`
export TARGET_PATH=$(pwd)/../../output/install_tools/
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH
TAR_SOURCE_FILE=1.5.0.tar.gz
SOURCE_FILE=pynacl-1.5.0
if [ -d ${SOURCE_FILE} ]; then
    rm -rf ${SOURCE_FILE}
fi
mkdir ${SOURCE_FILE}
tar -zxf $TAR_SOURCE_FILE -C $SOURCE_FILE --strip-components 1
cd $SOURCE_FILE
if [[ "$ARCH"x = "loongarch64"x ]];then
    cp -rf $(pwd)/../../../build-aux/* ./src/libsodium/build-aux/
fi
if [[ "$ARCH"x = "sw_64"x ]];then
    cp /usr/share/automake-1.16/config.guess ./src/libsodium/build-aux/config.guess
    cp /usr/share/automake-1.16/config.sub ./src/libsodium/build-aux/config.sub
fi
sed -i "s/\"wheel\"//g" setup.py
CFLAGS="-fstack-protector-strong -Wl,-z,relro,-z,now" python3 setup.py build

version_num=("3.6" "3.7" "3.8" "3.9" "3.10" "3.11")
lib_dir=""
for (( i=0;i<${#version_num[*]};i++ ))
do
    if [[ $(python3 -V | awk '{print $2}') =~ ${version_num[$i]} ]]; then
        lib_dir="lib${version_num[$i]}"
        break
    fi
done

if [[ "$PLATFORM" == centos* ]]; then
    CPU_BIT=$(uname -m)
    if [ X"$CPU_BIT" = X"x86_64" ]; then
        gcc -pthread -shared -Wl,-z,relro,-z,now,-z,noexecstack -s -ftrapv -g build/temp.linux-x86_64-$python_version/build/temp.linux-x86_64-$python_version/_sodium.o -Lbuild/temp.linux-x86_64-$python_version/lib -Lbuild/temp.linux-x86_64-$python_version/lib64 -Lbuild/temp.linux-x86_64-$python_version -lsodium -lsodium -o build/lib.linux-x86_64-$python_version/nacl/_sodium.abi3.so
    fi
fi

python3 setup.py install --user
if [[ -d "$TARGET_PATH/nacl" ]]; then
    mkdir -p $TARGET_PATH/nacl/$lib_dir
    cp build/lib*/nacl/_sodium.abi3.so $TARGET_PATH/nacl/$lib_dir
else
    cp -r build/lib*/* $TARGET_PATH
    mkdir -p $TARGET_PATH/nacl/$lib_dir
    mv $TARGET_PATH/nacl/_sodium.abi3.so $TARGET_PATH/nacl/$lib_dir
fi

# add boost script
cp ${ROOT_DIR}/_sodium.py $TARGET_PATH/nacl/
