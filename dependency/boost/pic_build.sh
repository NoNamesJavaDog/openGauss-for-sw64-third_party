#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2010-2018. All rights reserved.
# description: the script that make install boost
# date: 2020-11-20
# version: 1.72.0

set -e

#################################################
cd boost
cp libs/atomic/src/lock_pool_init1.ipp boost/preprocessor/iteration/detail/iter/limits
cp libs/atomic/src/lock_pool_init256.ipp boost/preprocessor/iteration/detail/iter/limits
rm -rf stage/*

################################################
#
#Building the Boost C++ Libraries.
#
#
#Performing configuration checks
#
#    - lockfree boost::atomic_flag : yes (cached)
#
#Component configuration:
#
#    - atomic                   : building
#    - chrono                   : building
#    - container                : not building
#    - context                  : not building
#    - coroutine                : not building
#    - date_time                : not building
#    - exception                : not building
#    - filesystem               : not building
#    - graph                    : not building
#    - graph_parallel           : not building
#    - iostreams                : not building
#    - locale                   : not building
#    - log                      : not building
#    - math                     : not building
#    - mpi                      : not building
#    - program_options          : not building
#    - python                   : not building
#    - random                   : not building
#    - regex                    : not building
#    - serialization            : not building
#    - signals                  : not building
#    - system                   : building
#    - test                     : not building
#    - thread                   : building
#    - timer                    : not building
#    - wave                     : not building
#
#...patience...
#...patience...
#...found 1506 targets...
#...updating 34 targets...

#common.mkdir stage/lib

        mkdir -p "stage/lib"

#common.mkdir stage/boost/bin.v2/libs/atomic

        mkdir -p "stage/boost/bin.v2/libs/atomic"
    
#common.mkdir stage/boost/bin.v2/libs/atomic/build

        mkdir -p "stage/boost/bin.v2/libs/atomic/build"
    
#common.mkdir stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7

        mkdir -p "stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7"
    
#common.mkdir stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release

        mkdir -p "stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release"
    
#common.mkdir stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release/link-static

        mkdir -p "stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release/link-static"
    
#common.mkdir stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release/link-static/threading-multi

        mkdir -p "stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release/link-static/threading-multi"
    
#gcc.compile.c++ stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release/link-static/threading-multi/lockpool.o

    "g++" -fPIC -fstack-protector  -ftemplate-depth-128 -O3 -finline-functions -Wno-inline -Wall -pthread  -DBOOST_ALL_NO_LIB=1 -DBOOST_ATOMIC_SOURCE -DBOOST_ATOMIC_STATIC_LINK=1 -DNDEBUG  -I"." -c -o "stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release/link-static/threading-multi/lock_pool.o" "libs/atomic/src/lock_pool.cpp"

#RmTemps stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release/link-static/threading-multi/libboost_atomic.a(clean)

    rm -f "stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release/link-static/threading-multi/libboost_atomic.a" 

#gcc.archive stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release/link-static/threading-multi/libboost_atomic.a

    "/usr/bin/ar"  rc "stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release/link-static/threading-multi/libboost_atomic.a" "stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release/link-static/threading-multi/lock_pool.o"
    "/usr/bin/ranlib" "stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release/link-static/threading-multi/libboost_atomic.a"

#common.copy stage/lib/libboost_atomic.a

    cp "stage/boost/bin.v2/libs/atomic/build/gcc-4.4.7/release/link-static/threading-multi/libboost_atomic.a"  "stage/lib/libboost_atomic.a"

#common.mkdir stage/boost/bin.v2/libs/system/build/gcc-4.4.7/release/link-static

        mkdir -p "stage/boost/bin.v2/libs/system/build/gcc-4.4.7/release/link-static"
    
#common.mkdir stage/boost/bin.v2/libs/system/build/gcc-4.4.7/release/link-static/threading-multi

        mkdir -p "stage/boost/bin.v2/libs/system/build/gcc-4.4.7/release/link-static/threading-multi"
    
#gcc.compile.c++ stage/boost/bin.v2/libs/system/build/gcc-4.4.7/release/link-static/threading-multi/error_code.o

    "g++" -fPIC -fstack-protector  -ftemplate-depth-128 -O3 -finline-functions -Wno-inline -Wall -pedantic -pthread  -DBOOST_ALL_NO_LIB=1 -DBOOST_SYSTEM_STATIC_LINK=1 -DNDEBUG  -I"." -c -o "stage/boost/bin.v2/libs/system/build/gcc-4.4.7/release/link-static/threading-multi/error_code.o" "libs/system/src/error_code.cpp"

#RmTemps stage/boost/bin.v2/libs/system/build/gcc-4.4.7/release/link-static/threading-multi/libboost_system.a(clean)

    rm -f "stage/boost/bin.v2/libs/system/build/gcc-4.4.7/release/link-static/threading-multi/libboost_system.a" 

#gcc.archive stage/boost/bin.v2/libs/system/build/gcc-4.4.7/release/link-static/threading-multi/libboost_system.a

    "/usr/bin/ar"  rc "stage/boost/bin.v2/libs/system/build/gcc-4.4.7/release/link-static/threading-multi/libboost_system.a" "stage/boost/bin.v2/libs/system/build/gcc-4.4.7/release/link-static/threading-multi/error_code.o"
    "/usr/bin/ranlib" "stage/boost/bin.v2/libs/system/build/gcc-4.4.7/release/link-static/threading-multi/libboost_system.a"

#common.copy stage/lib/libboost_system.a

    cp "stage/boost/bin.v2/libs/system/build/gcc-4.4.7/release/link-static/threading-multi/libboost_system.a"  "stage/lib/libboost_system.a"

#common.mkdir stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static

        mkdir -p "stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static"
    
#common.mkdir stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi

        mkdir -p "stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi"
    
#gcc.compile.c++ stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/chrono.o

    "g++" -fPIC -fstack-protector  -ftemplate-depth-128 -O3 -finline-functions -Wno-inline -Wall -pedantic -pthread -Wextra -Wno-long-long -Wno-variadic-macros -pedantic -DBOOST_ALL_NO_LIB=1 -DBOOST_All_STATIC_LINK=1 -DBOOST_SYSTEM_NO_DEPRECATED -DBOOST_SYSTEM_STATIC_LINK=1 -DNDEBUG  -I"." -c -o "stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/chrono.o" "libs/chrono/src/chrono.cpp"

#gcc.compile.c++ stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/thread_clock.o

    "g++" -fPIC -fstack-protector  -ftemplate-depth-128 -O3 -finline-functions -Wno-inline -Wall -pedantic -pthread -Wextra -Wno-long-long -Wno-variadic-macros -pedantic -DBOOST_ALL_NO_LIB=1 -DBOOST_All_STATIC_LINK=1 -DBOOST_SYSTEM_NO_DEPRECATED -DBOOST_SYSTEM_STATIC_LINK=1 -DNDEBUG  -I"." -c -o "stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/thread_clock.o" "libs/chrono/src/thread_clock.cpp"

#gcc.compile.c++ stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/process_cpu_clocks.o

    "g++" -fPIC -fstack-protector  -ftemplate-depth-128 -O3 -finline-functions -Wno-inline -Wall -pedantic -pthread -Wextra -Wno-long-long -Wno-variadic-macros -pedantic -DBOOST_ALL_NO_LIB=1 -DBOOST_All_STATIC_LINK=1 -DBOOST_SYSTEM_NO_DEPRECATED -DBOOST_SYSTEM_STATIC_LINK=1 -DNDEBUG  -I"." -c -o "stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/process_cpu_clocks.o" "libs/chrono/src/process_cpu_clocks.cpp"

#RmTemps stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/libboost_chrono.a(clean)

    rm -f "stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/libboost_chrono.a" 

#gcc.archive stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/libboost_chrono.a

    "/usr/bin/ar"  rc "stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/libboost_chrono.a" "stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/chrono.o" "stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/thread_clock.o" "stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/process_cpu_clocks.o"
    "/usr/bin/ranlib" "stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/libboost_chrono.a"

#common.copy stage/lib/libboost_chrono.a

    cp "stage/boost/bin.v2/libs/chrono/build/gcc-4.4.7/release/link-static/threading-multi/libboost_chrono.a"  "stage/lib/libboost_chrono.a"

#common.mkdir stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release

        mkdir -p "stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release"
    
#common.mkdir stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static

        mkdir -p "stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static"
    
#common.mkdir stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi

        mkdir -p "stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi"
    
#common.mkdir stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/pthread

        mkdir -p "stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/pthread"
    
#gcc.compile.c++ stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/pthread/thread.o

    "g++" -fPIC -fstack-protector  -ftemplate-depth-128 -O3 -finline-functions -Wno-inline -Wall -pedantic -pthread -Wextra -Wno-long-long -Wno-variadic-macros -Wunused-function -pedantic -DBOOST_ALL_NO_LIB=1 -DBOOST_SYSTEM_STATIC_LINK=1 -DBOOST_THREAD_BUILD_LIB=1 -DBOOST_THREAD_DONT_USE_CHRONO -DBOOST_THREAD_POSIX -DNDEBUG  -I"." -c -o "stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/pthread/thread.o" "libs/thread/src/pthread/thread.cpp"

#gcc.compile.c++ stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/pthread/once.o

    "g++" -fPIC -fstack-protector  -ftemplate-depth-128 -O3 -finline-functions -Wno-inline -Wall -pedantic -pthread -Wextra -Wno-long-long -Wno-variadic-macros -Wunused-function -pedantic -DBOOST_ALL_NO_LIB=1 -DBOOST_SYSTEM_STATIC_LINK=1 -DBOOST_THREAD_BUILD_LIB=1 -DBOOST_THREAD_DONT_USE_CHRONO -DBOOST_THREAD_POSIX -DNDEBUG  -I"." -c -o "stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/pthread/once.o" "libs/thread/src/pthread/once.cpp"

#gcc.compile.c++ stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/future.o

    "g++" -fPIC -fstack-protector  -ftemplate-depth-128 -O3 -finline-functions -Wno-inline -Wall -pedantic -pthread -Wextra -Wno-long-long -Wno-variadic-macros -Wunused-function -pedantic -DBOOST_ALL_NO_LIB=1 -DBOOST_SYSTEM_STATIC_LINK=1 -DBOOST_THREAD_BUILD_LIB=1 -DBOOST_THREAD_DONT_USE_CHRONO -DBOOST_THREAD_POSIX -DNDEBUG  -I"." -c -o "stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/future.o" "libs/thread/src/future.cpp"

#RmTemps stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/libboost_thread.a(clean)

    rm -f "stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/libboost_thread.a" 

#gcc.archive stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/libboost_thread.a

    "/usr/bin/ar"  rc "stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/libboost_thread.a" "stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/pthread/thread.o" "stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/pthread/once.o" "stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/future.o"
    "/usr/bin/ranlib" "stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/libboost_thread.a"

#common.copy stage/lib/libboost_thread.a

    cp "stage/boost/bin.v2/libs/thread/build/gcc-4.4.7/release/link-static/threading-multi/libboost_thread.a"  "stage/lib/libboost_thread.a"

#...updated 34 targets...
#
#
#The Boost C++ Libraries were successfully built!
#
#The following directory should be added to compiler include paths:
#
#    /home/test/V1R5C10/br_Gauss200_OLAP_V100R005C10_BaseLine/3rd_src/boost/boost_1_57_0
#
#The following directory should be added to linker library paths:
#
#    /home/test/V1R5C10/br_Gauss200_OLAP_V100R005C10_BaseLine/3rd_src/boost/boost_1_57_0/stage/lib
