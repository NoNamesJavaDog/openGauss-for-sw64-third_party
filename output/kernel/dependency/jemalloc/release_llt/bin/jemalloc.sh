#!/bin/sh

prefix=/root/openGauss-third_party/dependency/jemalloc/install_release
exec_prefix=/root/openGauss-third_party/dependency/jemalloc/install_release
libdir=${exec_prefix}/lib

LD_PRELOAD=${libdir}/libjemalloc.so.2
export LD_PRELOAD
exec "$@"
