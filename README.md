### openGauss-third_party

这个仓库用来编译openGauss依赖的所有开源三方软件。 本库的一些大文件通过[Git LFS](https://git-lfs.github.com/)扩展管理，Git clone这个库时，需要确保Git安装了此插件。

这些开源文件通过以下方式处理：
    1. 直接引用代码，例如masstree
    2. 生成动态或静态库。

有四个目录 \
    a、 build目录包括可以构建我们所依赖的所有第三方的脚本。 \
    b、 buildtools包括用于编译这些opensources和openGauss服务器的构建工具。\
    c、 dependency包括openGauss服务器的所有依赖的开源组件。\
    d、 platform包括openjdk等开源软件。
	
### 编译好的二进制

社区提供编译好的三方库二进制，可以直接使用，版本和三方库下载地址对应如下：

<table>
    <tr>
    	<td>分支</td>
        <td>tag</td>
        <td>gcc版本</td>
        <td>下载路径</td>
    </tr>
    <tr>
    	<td rowspan=2>1.0.0</td>
        <td>v1.0.0</td>
        <td rowspan=2>gcc7.3</td>
        <td rowspan=2><a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/1.0.0/openGauss-third_party_binarylibs.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/1.0.0/openGauss-third_party_binarylibs.tar.gz</a></td>
        <tr><td>v1.0.1</td></tr> 
    </tr>
    <tr>
    	<td rowspan=1>1.1.0</td>
        <td>v1.1.0</td>
        <td>gcc7.3</td>
        <td rowspan=1><a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/1.1.0/openGauss-third_party_binarylibs.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/1.1.0/openGauss-third_party_binarylibs.tar.gz</a></td>
    </tr>
    <tr>
    	<td rowspan=6>2.0.0</td>
        <td>v2.0.0</td>
        <td rowspan=6>gcc7.3</td>
        <td rowspan=6><a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/2.0.0/openGauss-third_party_binarylibs.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/2.0.0/openGauss-third_party_binarylibs.tar.gz</a></td>
        <tr><td>v2.0.1</td></tr>
        <tr><td>v2.0.2</td></tr>
        <tr><td>v2.0.3</td></tr>
        <tr><td>v2.0.4</td></tr>
        <tr><td>v2.0.5</td></tr>
    </tr>
    <tr>
        <td rowspan=1>2.1.0</td>
        <td>v2.1.0</td>
        <td>gcc7.3</td>
        <td rowspan=1><a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/2.1.0/openGauss-third_party_binarylibs.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/2.1.0/openGauss-third_party_binarylibs.tar.gz</a></td>
    </tr>
    <tr>
        <td rowspan=4>3.0.0</td>
        <td>v3.0.0</td>
        <td rowspan=4>gcc7.3</td>
        <td rowspan=3><a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/3.0.0/openGauss-third_party_binarylibs.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/3.0.0/openGauss-third_party_binarylibs.tar.gz</a></td>
        <tr><td>v3.0.1</td></tr>
        <tr><td>v3.0.2</td></tr>
        <tr><td>v3.0.3</td>
        <td rowspan=1>
            <strong>openEuler_arm:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/3.0.0/binarylibs/openGauss-third_party_binarylibs_openEuler_arm-3.0.3.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/3.0.0/binarylibs/openGauss-third_party_binarylibs_openEuler_arm-3.0.3.tar.gz</a> <br/>
            <strong>openEuler_x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/3.0.0/binarylibs/openGauss-third_party_binarylibs_openEuler_x86_64-3.0.3.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/3.0.0/binarylibs/openGauss-third_party_binarylibs_openEuler_x86_64-3.0.3.tar.gz</a><br/>
            <strong>Centos_x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/3.0.0/binarylibs/openGauss-third_party_binarylibs_Centos7.6_x86_64-3.0.3.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/3.0.0/binarylibs/openGauss-third_party_binarylibs_Centos7.6_x86_64-3.0.3.tar.gz</a></td></tr>
        </tr>
    <tr>
        <td rowspan=2>3.1.0</td>
        <td>v3.1.0</td>
        <td rowspan=2>gcc7.3</td>
        <td rowspan=2>
           <strong>openEuler_arm:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/3.1.0/binarylibs/openGauss-third_party_binarylibs_openEuler_arm.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/3.1.0/binarylibs/openGauss-third_party_binarylibs_openEuler_arm.tar.gz</a></br>
            <strong>openEuler_x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/3.1.0/binarylibs/openGauss-third_party_binarylibs_openEuler_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/3.1.0/binarylibs/openGauss-third_party_binarylibs_openEuler_x86_64.tar.gz</a></br>
            <strong>Centos_x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/3.1.0/binarylibs/openGauss-third_party_binarylibs_Centos7.6_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/3.1.0/binarylibs/openGauss-third_party_binarylibs_Centos7.6_x86_64.tar.gz</a>
        </tr>
    </tr>
    <tr><td>v3.1.1</td></tr>
    <tr>
        <td rowspan=1>5.0.0</td>
        <td>v5.0.0</td>
        <td>gcc7.3</td>
        <td rowspan=1>
            <strong>openEuler 20.03 arm:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.0.0/binarylibs/openGauss-third_party_binarylibs_openEuler_arm.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.0.0/binarylibs/openGauss-third_party_binarylibs_openEuler_arm.tar.gz</a><br/>
            <strong>openEuler 20.03 x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.0.0/binarylibs/openGauss-third_party_binarylibs_openEuler_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.0.0/binarylibs/openGauss-third_party_binarylibs_openEuler_x86_64.tar.gz</a><br/>
            <strong>Centos_x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.0.0/binarylibs/openGauss-third_party_binarylibs_Centos7.6_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.0.0/binarylibs/openGauss-third_party_binarylibs_Centos7.6_x86_64.tar.gz</a><br/>
            <strong>openEuler 22.03 arm:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.0.0/binarylibs_2203/openGauss-third_party_binarylibs_openEuler_2203_arm.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.0.0/binarylibs_2203/openGauss-third_party_binarylibs_openEuler_2203_arm.tar.gz</a><br/>
            <strong>openEuler 22.03 x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.0.0/binarylibs_2203/openGauss-third_party_binarylibs_openEuler_2203_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.0.0/binarylibs_2203/openGauss-third_party_binarylibs_openEuler_2203_x86_64.tar.gz</a></td>
        </tr>
    </tr>
    <tr>
        <td rowspan=2>5.1.0</td>
        <td rowspan=2>v5.1.0</td>
        <td>gcc7.3</td>
        <td rowspan=1>
            <strong>openEuler 20.03 arm:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc7.3/openGauss-third_party_binarylibs_openEuler_arm.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc7.3/openGauss-third_party_binarylibs_openEuler_arm.tar.gz</a><br/>
            <strong>openEuler 20.03 x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc7.3/openGauss-third_party_binarylibs_openEuler_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc7.3/openGauss-third_party_binarylibs_openEuler_x86_64.tar.gz</a><br/>
            <strong>Centos_x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc7.3/openGauss-third_party_binarylibs_Centos7.6_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc7.3/openGauss-third_party_binarylibs_Centos7.6_x86_64.tar.gz</a><br/>
            <strong>openEuler 22.03 arm:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc7.3/openGauss-third_party_binarylibs_openEuler_2203_arm.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc7.3/openGauss-third_party_binarylibs_openEuler_2203_arm.tar.gz</a><br/>
            <strong>openEuler 22.03 x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc7.3/openGauss-third_party_binarylibs_openEuler_2203_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc7.3/openGauss-third_party_binarylibs_openEuler_2203_x86_64.tar.gz</a></td>
        </tr>
        <td>gcc10.3</td>
        <td rowspan=1>
            <strong>openEuler 20.03 arm:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_arm.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_arm.tar.gz</a><br/>
            <strong>openEuler 20.03 x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_x86_64.tar.gz</a><br/>
            <strong>Centos_x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_Centos7.6_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_Centos7.6_x86_64.tar.gz</a><br/>
            <strong>openEuler 22.03 arm:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2203_arm.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2203_arm.tar.gz</a><br/>
            <strong>openEuler 22.03 x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2203_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/5.1.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2203_x86_64.tar.gz</a></td>
        </tr>
    </tr>
    <tr>
        <td rowspan=1>6.0.0</td>
        <td rowspan=1></td>
        <td>gcc10.3</td>
        <td rowspan=1>
           <strong>openEuler_arm:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/6.0.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_arm.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/6.0.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_arm.tar.gz</a><br/>
            <strong>openEuler_x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/6.0.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/6.0.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_x86_64.tar.gz</a><br/>
            <strong>Centos_x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/6.0.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_Centos7.6_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/6.0.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_Centos7.6_x86_64.tar.gz</a><br/>
            <strong>openEuler 22.03 arm:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/6.0.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2203_arm.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/6.0.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2203_arm.tar.gz</a><br/>
            <strong>openEuler 22.03 x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/6.0.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2203_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/6.0.0/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2203_x86_64.tar.gz</a></td>
        </tr>
    </tr>
    <tr>
        <td rowspan=1>master</td>
        <td rowspan=1></td>
        <td>gcc10.3</td>
        <td rowspan=1>
           <strong>openEuler_arm:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_arm.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_arm.tar.gz</a><br/>
            <strong>openEuler_x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_x86_64.tar.gz</a><br/>
            <strong>Centos_x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_Centos7.6_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_Centos7.6_x86_64.tar.gz</a><br/>
            <strong>openEuler 22.03 arm:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2203_arm.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2203_arm.tar.gz</a><br/>
            <strong>openEuler 22.03 x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2203_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2203_x86_64.tar.gz</a><br/>
            <strong>openEuler 24.03 arm:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2403_arm.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2403_arm.tar.gz</a><br/>
            <strong>openEuler 24.03 x86:</strong> <a href="https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2403_x86_64.tar.gz">https://opengauss.obs.cn-south-1.myhuaweicloud.com/latest/binarylibs/gcc10.3/openGauss-third_party_binarylibs_openEuler_2403_x86_64.tar.gz</a></td>
        </tr>
    </tr>
</table>

社区提供了已编译好的`centos7.6_x86, openeuler20.03_aarch64,openeuler22.03_aarch64,openeuler24.03_aarch64,openeuler20.03_x86,openeuler22.03_x86,openeuler24.03_x86` 七个操作系统的二进制文件。
从3.1.0版本开始，每个系统提供独立的二级制文件使用。各个系统分别需要下载对应的文件。
对于其他系统，需要自行编译，可以按照下方的步骤执行：

### 安装依赖

使用下面的步骤来构建开源软件的二进制目录，用来编译openGauss数据库。\
请确保在构建前，服务器已经安装了`gcc gcc-c++` \
开始编译二进制前，还需要下面这些依赖，可以通过yum install进行安装。

```
libaio-devel
ncurses-devel
pam-devel
libffi-devel
python3-devel
libtool
libtool-devel 
libtool-ltdl
python-devel
openssl-devel
bison
python3-setuptools-rust
lz4-devel
```
部分组件的编译需要Rust工具链，使用如下命令安装：
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```
同时，openEuler-20.03系统上需升级setuptools包，并安装setuptools-rust：
```
pip3 install --upgrade setuptools==46.4.0
pip3 install setuptools-rust==0.11.4
```
同时centos系统上配置完gcc-10.3环境变量后，需要将cc命令链接到gcc上。
```
ln -s gcc cc
```
### 编译gcc和cmake
1. 编译gcc
    三方库编译还需要依赖gcc10.3版本，如果是openEuler+ARM就用10.3.1版本，其他版本用10.3.0版本。

    **gcc10.3.0:**

    下载[gcc-10.3.0.zip](https://github.com/gcc-mirror/gcc/archive/refs/tags/releases/gcc-10.3.0.zip) 或者 [gcc-10.3.0.tar.gz](https://github.com/gcc-mirror/gcc/archive/refs/tags/releases/gcc-10.3.0.tar.gz)，解压后进行编译安装。

    **gcc10.3.1:**

    通过git clone下载openEuler提供的gcc10.3.1的源码，并进行编译安装。
    ```
    git clone https://gitee.com/openeuler/gcc.git -b gcc-10
    ```
2. 编译cmake
    三方库编译依赖cmake(建议版本：3.20)，cmake (https://cmake.org/download/#latest) 并解压后编译。
    推荐使用下载的cmake包(https://cmake.org/files/v3.20/) 无需编译，防止gcc版本与cmake不兼容导致的冲突无法使用。

编译完成后，将gcc10.3和cmake导入到环境变量中（下一步的三方库编译依赖这两个），例如：

```
export CMAKEROOT=/usr/local/cmake3.20
export GCC_PATH=/opt/gcc/gcc10.3
export CC=$GCC_PATH/gcc/bin/gcc
export CXX=$GCC_PATH/gcc/bin/g++
export LD_LIBRARY_PATH=$GCC_PATH/gcc/lib64:$GCC_PATH/isl/lib:$GCC_PATH/mpc/lib/:$GCC_PATH/mpfr/lib/:$GCC_PATH/gmp/lib/:$CMAKEROOT/lib:$LD_LIBRARY_PATH
export PATH=$GCC_PATH/gcc/bin:$CMAKEROOT/bin:$PATH
```

### 编译三方库

进入到`openGauss-third_party/build` 目录下，执行`sh build_all.sh`，编译全量的三方组件。 

build_all.sh中先编译了openssl，然后编译buildtools, platform, dependency 和 component，可以对这三个按顺序分别编译:

***build tools***
```
cd openGauss-third_party/build_tools
sh build_tools.sh
```

***build platform***
```
cd openGauss-third_party/platform/build/
sh build_platform.sh
```

***build dependency***
```
cd openGauss-third_party/dependency/build/
sh build_dependency.sh
```

***build component***
```
cd openGauss-third_party/component/build/
sh build_component.sh
```

### openEuler系统编译Python3

由于openEuler系统上openssl版本与openGauss三方库中版本不一致导致的兼容性问题，在使用OM安装，建立互信时候会出现错误。在openEuler上编译三方库完成后还需要编译下Python3。
操作如下：
```
cd openGauss-third_party/build_tools/python3
sh build.sh
```

### 编译完成

编译完成后，编译结果在`openGauss-third_party/output`目录下。 \
还需要在`openGauss-third_party/output/buildtools/` 下，将编译好的gcc10.3拷贝到该目录下。 \
如：gcc10.3的路径为：`output/buildtools/gcc10.3`

以上步骤完成后，`openGauss-third_party/output`目录就是完整的三方库二进制。可以用来进行数据库编译。
