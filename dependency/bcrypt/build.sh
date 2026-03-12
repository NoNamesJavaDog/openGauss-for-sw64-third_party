# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
# description: the script that make install bcrypt
# version: 3.1.7
# date:
# history:
#######################################################################
set -e
ROOT_DIR=$(pwd)
PLATFORM=$(sh $(pwd)/../../build/get_PlatForm_str.sh)
mkdir -p $(pwd)/../../output/install_tools/
python_version=`python3 -V | awk -F ' ' '{print $2}' |awk -F '.' -v OFS='.' '{print $1,$2}'`
export TARGET_PATH=$(pwd)/../../output/install_tools
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export PATH=$TARGET_PATH:$PATH
export PYTHONPATH=$TARGET_PATH:$PYTHONPATH
TAR_SOURCE_FILE=3.2.2.tar.gz
SOURCE_FILE=bcrypt-3.2.2
if [ -d ${SOURCE_FILE} ]; then
    rm -rf ${SOURCE_FILE}
fi
mkdir ${SOURCE_FILE}
tar -zxf $TAR_SOURCE_FILE -C $SOURCE_FILE --strip-components 1
cd $SOURCE_FILE
CFLAGS='-fstack-protector-all' LDFLAGS='-Wl,-z,relro,-z,now -z,noexecstack' python3 setup.py build

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
        gcc -pthread -shared -Wl,-z,relro,-z,now,-z,noexecstack -s -ftrapv -g build/temp.linux-x86_64-$python_version/build/temp.linux-x86_64-$python_version/_bcrypt.o build/temp.linux-x86_64-$python_version/src/_csrc/blf.o build/temp.linux-x86_64-$python_version/src/_csrc/bcrypt.o build/temp.linux-x86_64-$python_version/src/_csrc/bcrypt_pbkdf.o build/temp.linux-x86_64-$python_version/src/_csrc/sha2.o build/temp.linux-x86_64-$python_version/src/_csrc/timingsafe_bcmp.o  -o build/lib.linux-x86_64-$python_version/bcrypt/_bcrypt.abi3.so
    fi
fi

python3 setup.py install --user
if [[ -d "$TARGET_PATH/bcrypt" ]]; then
    mkdir -p $TARGET_PATH/bcrypt/$lib_dir
    cp build/lib*/bcrypt/_bcrypt.abi3.so $TARGET_PATH/bcrypt/$lib_dir
else
    cp -r build/lib*/* $TARGET_PATH
    mkdir -p $TARGET_PATH/bcrypt/$lib_dir
    mv $TARGET_PATH/bcrypt/_bcrypt.abi3.so $TARGET_PATH/bcrypt/$lib_dir
fi

cp $ROOT_DIR/_bcrypt.py $TARGET_PATH/bcrypt/
