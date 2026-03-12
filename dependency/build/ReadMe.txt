1.先编build_buildtools，并将编译好的gcc、java、golang加入环境变量（gcc不确定是否可用，目前是用的替换的）
编译基本工具cmake-3.16.5、automake-1.16、bison-3.0.5，并将编译好的工具加入环境变量

export GCCFOLDER=/home/tz/software/gcc
export GOROOT=/home/tz/software/go
export BISONROOT=/home/tz/software/bison
export CMAKEROOT=/home/tz/software/cmake
export CC=$GCCFOLDER/bin/gcc
export CXX=$GCCFOLDER/bin/g++
export LD_LIBRARY_PATH=$GCCFOLDER/lib64:$GCCFOLDER/isl/lib:$GCCFOLDER/mpc/lib/:$GCCFOLDER/mpfr/lib/:$GCCFOLDER/gmp/lib/:$CMAKEROOT/lib:$OPENSSLROOT/lib:$LD_LIBRARY_PATH
export PATH=$GCCFOLDER/bin:$GOROOT/bin:$BISONROOT/bin:$CMAKEROOT/bin:$PATH

如果在编译上述基础工具的时候提示环境变量里没有libssl，可以用gcc8.2先编译openssl，并将编译完的动态库加入环境变量
export OPENSSLROOT=/home/tz/GaussDB_Kernel_TRUNK/binarylibs/euleros2.0_sp2_x86_64/openssl/comm
export LD_LIBRARY_PATH=$OPENSSLROOT/lib:$LD_LIBRARY_PATH


用gcc8.2在当前用户下编译python2.7.15，并将编译完的python加入环境变量
export PYTHONDIR=/home/tz/software/python27
export PATH=$PYTHONDIR/bin:$PATH
export PYTHONPATH=$PYTHONDIR/site-packages:$PYTHONPATH



2.顺序编译build_first、build_second、build_pylib