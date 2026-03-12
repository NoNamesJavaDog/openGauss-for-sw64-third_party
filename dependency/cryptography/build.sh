#!/bin/bash
# Copyright (c): 2012-2019, Huawei Tech. Co., Ltd.
set -e
ROOT_DIR=$(pwd)
mkdir -p $(pwd)/../python-lib
mkdir -p $(pwd)/../../output/install_tools
python_version=`python3 -V | awk -F ' ' '{print $2}' |awk -F '.' -v OFS='.' '{print $1,$2}'`
export TARGET_PATH=$(pwd)/../../output/install_tools/
export OPENSSL_ROOT_DIR=$(pwd)/../../output/kernel/dependency/openssl/comm
export OPENSSL_DIR=$(pwd)/../../output/kernel/dependency/openssl/comm
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH
export LIBRARY_PATH=${OPENSSL_DIR}/lib:${OPENSSL_ROOT_DIR}/lib:$LIBRARY_PATH
export C_INCLUDE_PATH=$C_INCLUDE_PATH:${OPENSSL_DIR}/include:${OPENSSL_ROOT_DIR}/lib
TAR_SOURCE_FILE=40.0.2.tar.gz
SOURCE_FILE=cryptography-40.0.2
if [ -d ${SOURCE_FILE} ]; then
    rm -rf ${SOURCE_FILE}
fi
mkdir ${SOURCE_FILE}

version_num=("3.6" "3.7" "3.8" "3.9" "3.10" "3.11")
lib_dir=""
for (( i=0;i<${#version_num[*]};i++ ))
do
    if [[ $(python3 -V | awk '{print $2}') =~ ${version_num[$i]} ]]; then
        lib_dir="lib${version_num[$i]}"
        break
    fi
done

# ---- sw_64: use system cryptography 3.3.1 (Rust libc crate lacks sw_64 support) ----
if [[ $(uname -m) == "sw_64" ]]; then
    echo "[cryptography] sw_64: using system cryptography 3.3.1"
    SYS_CRYPTO=/usr/lib/python3.7/site-packages/cryptography
    cp -r ${SYS_CRYPTO} ${TARGET_PATH}/
    mkdir -p ${TARGET_PATH}/cryptography/hazmat/bindings/lib3.7
    for so in ${TARGET_PATH}/cryptography/hazmat/bindings/*.so; do
        [ -f "$so" ] && mv "$so" ${TARGET_PATH}/cryptography/hazmat/bindings/lib3.7/
    done
    cp $ROOT_DIR/_openssl.py $TARGET_PATH/cryptography/hazmat/bindings/
    cp $ROOT_DIR/_padding.py $TARGET_PATH/cryptography/hazmat/bindings/
    echo "[cryptography] sw_64: done"
    exit 0
fi
tar -zxf $TAR_SOURCE_FILE -C $SOURCE_FILE --strip-components 1
cd $SOURCE_FILE
sed -i '/^if sys.version_info\[:2\] == (3, 6):/,/^    )/ s/^/# /' ./src/cryptography/__init__.py
patch -p1 < ../CVE-2023-38325.patch
patch -p1 < ../CVE-2023-49083.patch
patch -p1 < ../CVE-2024-26130.patch

export CFLAGS="-fstack-protector-all"
export LDFLAGS="-Wl,-z,relro,-z,now,-z,noexecstack"

python3 setup.py build_ext --inplace --library-dirs=${OPENSSL_ROOT_DIR}/lib --include-dirs=${OPENSSL_ROOT_DIR}/include

python3 setup.py install --user

if [[ -d "$TARGET_PATH/cryptography/hazmat/bindings" ]]; then
    mkdir -p $TARGET_PATH/cryptography/hazmat/bindings/$lib_dir
    cp build/lib*/cryptography/hazmat/bindings/*.so $TARGET_PATH/cryptography/hazmat/bindings/$lib_dir
else
    cp -r build/lib*/* $TARGET_PATH
    mkdir -p $TARGET_PATH/cryptography/hazmat/bindings/$lib_dir
    mv $TARGET_PATH/cryptography/hazmat/bindings/*.so $TARGET_PATH/cryptography/hazmat/bindings/$lib_dir
fi

cp $ROOT_DIR/_openssl.py $TARGET_PATH/cryptography/hazmat/bindings/
cp $ROOT_DIR/_padding.py $TARGET_PATH/cryptography/hazmat/bindings/
