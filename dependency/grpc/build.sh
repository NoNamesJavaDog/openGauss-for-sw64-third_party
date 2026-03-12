#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
# description: the script that make install grpc
# date: 2020-11-25
# version: 1.0
# history:
# 2020-11-25 first commit

#######################################################################
# main
#######################################################################
WORK_PATH="$(dirname $0)"
tmp_cpus=$(grep -w processor /proc/cpuinfo|wc -l)

source "${WORK_PATH}/build_common.sh"
sed -i -e "194d" -e "196d" -e "197d" -e "199d" \
-e "193 a set(_gRPC_CARES_LIBRARIES ${TO_3RD}/lib/libcares.a)" \
-e "193 a set(_gRPC_CARES_INCLUDE_DIR ${TO_3RD}/include)" \
-e "195 a set(_gRPC_PROTOBUF_LIBRARIES ${TO_3RD}/lib/libprotoc.a ${TO_3RD}/lib/libprotobuf.a ${TO_3RD}/lib/libprotobuf-lite.a)" \
-e "195 a set(_gRPC_PROTOBUF_INCLUDE_DIR ${TO_3RD}/include)" \
-e "195 a set(_gRPC_PROTOBUF_PROTOC_EXECUTABLE `which protoc`)" \
-e "195 a set(_gRPC_SSL_LIBRARIES ${TO_3RD}/lib/libssl.so ${TO_3RD}/lib/libcrypto.so)" \
-e "195 a set(_gRPC_SSL_INCLUDE_DIR ${TO_3RD}/include)" \
-e "195 a set(_gRPC_ZLIB_LIBRARIES ${TO_3RD}/lib/libz.a)" \
-e "195 a set(_gRPC_ZLIB_INCLUDE_DIR ${TO_3RD}/include)" ../CMakeLists.txt
sed -i '169a set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIE -fPIC -fstack-protector-all -Wstack-protector -s -Wl,-z,relro,-z,now,-z,noexecstack")' ../CMakeLists.txt
sed -i '167a set(CMAKE_C_FLAGS "-fPIE -fPIC -fstack-protector-all -Wstack-protector -s -Wl,-z,relro,-z,now,-z,noexecstack")' ../CMakeLists.txt
export PKG_CONFIG_PATH=../../protobuf/install_comm/lib
cmake .. -G "Unix Makefiles" \
  -DCMAKE_CXX_FLAGS="-w -std=c++11 -D_GLIBCXX_USE_CXX11_ABI=0 " \
  -DCMAKE_C_FLAGS="-w -std=c99 -D_GLIBCXX_USE_CXX11_ABI=0 " \
  -DCMAKE_INSTALL_PREFIX=${LOCAL_DIR}/install \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DgRPC_ZLIB_PROVIDER=package \
  -DgRPC_CARES_PROVIDER=package \
  -DgRPC_PROTOBUF_PROVIDER=package \
  -D_gRPC_PROTOBUF_WELLKNOWN_INCLUDE_DIR=${TO_3RD}/include \
  -DgRPC_SSL_PROVIDER=package \
  -DABSL_ROOT_DIR=$CUR_SRC/third_party/abseil-cpp \
  -DGFLAGS_ROOT_DIR=$CUR_SRC/third_party/gflags \
  -DBENCHMARK_ROOT_DIR=$CUR_SRC/third_party/benchmark \
  -DRUN_HAVE_STD_REGEX=0 \
  -DRUN_HAVE_POSIX_REGEX=0 \
  -DRUN_HAVE_STEADY_CLOCK=0 \
  -DBUILD_SHARED_LIBS=ON \
  -DBENCHMARK_ENABLE_TESTING=OFF

sed -i "s/CC/CXX/g" CMakeFiles/grpc_create_jwt.dir/link.txt
sed -i "s/CC/CXX/g" CMakeFiles/grpc_verify_jwt.dir/link.txt
sed -i "s/CC/CXX/g" CMakeFiles/grpc_print_google_default_creds_token.dir/link.txt
make clean && make -j${tmp_cpus}
make install -j${tmp_cpus}
mkdir -p ../../../../output/dependency/$platform/grpc/comm/include && mkdir -p ../../../../output/dependency/$platform/grpc/llt/include
mkdir -p ../../../../output/dependency/$platform/grpc/comm/lib && mkdir -p ../../../../output/dependency/$platform/grpc/llt/lib
cp -rL ../../install/lib/lib* ../../../../output/dependency/$platform/grpc/comm/lib
cp -rL ../../install/lib/lib* ../../../../output/dependency/$platform/grpc/llt/lib
cp -r ../include/* ../../../../output/dependency/$platform/grpc/comm/include
cp -r ../include/* ../../../../output/dependency/$platform/grpc/llt/include
