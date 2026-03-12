第三方插件的编译和插装，以及新增部署

1） 编译参数说明
组件的编译需要提供release/debug/release_llt/debug_llt四种版本，由于有的组件无论是被release/debug/llt引用都是用的同一种组件编译版本，那么我们规划了comm版本和llt版本；下面对集中版本的含义进行说明：
comm：组件编译不区分release/debug版本；
release/debug：组件编译需要区分release/debug版本；
llt：对于llt编译不区分release/debug版本；
release_llt/debug_llt：llt组件编译需要区分release和debug版本；
所以在组件目录下分别建立了comm  debug  debug_llt  llt  release  release_llt六个目录，各组件可以根据实际情况进行区分
例如：实际安装路径 /home/mpp/br_Gauss_OLAP_V100R005C00_MC2000/binarylibs/redhat6.4_x86_64/event/comm
说明：/home/mpp/br_Gauss_OLAP_V100R005C00_MC2000  -->版本根目录
	  binarylibs								  -->插件类型
	  redhat6.4_x86_64							  -->操作系统，版本号，平台类型
	  event										  -->插件名插件名称
	  comm										  -->编译参数说明
	  
2）对于3rd_src目录里面每一个组件单独存放一个目录，各个目录互不影响。提供一键式编译脚本和单独组件编译脚本，可以全部编译，也可以独立编译，编译架构提供灵活性。

3）单独组件编译配置：配置文件名称为config.ini，配置文件config.ini记录组件的所属类别和编译目标。
Eg：
binarylibs@event=comm|llt
说明： binarylibs  	-->插件类型。
	   event		-->插件名称， 该名称同实际安装路径的名称需对应；
	   comm|llt		-->编译参数说明。
注意：不要重复配置一个插件，这样会导致筛选组件信息时异常错误。

4）单独组件编译脚本：在每个组件目录下提供build.sh脚本，脚本提供如下接口：
-h|--help：提供此脚本的使用帮助信息
-m|--build_option：。
此编译脚本提供如下参数：
-h|--help：提供此脚本的使用帮助信息
-m|--build_option ：提供编译、适配、发布和清理几个选项，各选项含义如下：
  build：编译并本地安装组件。
  shrink：将本地编译的组件进行筛选，只提供编译Gauss200 OLAP需要的文件。
  dist：将筛选完毕的文件发布到Gauss200 OLAP编译框架对应的平台目录中。  
  clean：将组件本地编译和安装产生的目录和文件清理掉。
  
5）全局编译配置：使用配置文件config.ini记录所有组件的组件类别和编译目标
全局编译配置默认是所有单独组件编译配置文件的总和。在编译时指定的组件名称参数必须和这个名称匹配。
Eg：
binarylibs@event=comm|llt
binarylibs@zlib1.2.7=comm|llt
注意：不要重复配置一个插件，这样会导致筛选组件信息时异常错误。

6）全局编译脚本: 在3rd_src目录开发一个build_all.sh脚本用来编译Gauss200 OLAP依赖的所有组件，实现一键式编译。此编译脚本提供如下参数：
-h|--help：提供此脚本的使用帮助信息
-m|--build_option ：提供编译、适配、发布和清理几个选项，各选项含义如下：
  build：编译并本地安装组件。
  shrink：将本地编译的组件进行赛选，只提供编译Gauss200 OLAP需要的文件。
  dist：将赛选完毕的文件发布到Gauss200 OLAP编译框架对应的平台目录中。
  clean：将组件本地编译和安装产生的目录和文件清理掉。
-p|--pkg ：指定编译的组件名称，编译所有指定all。

7）全局脚本在实现的过程中，遍历调用全局配置config.ini中提供的所有组件的build.sh。一旦异常，立即退出。

8）如何实现新增加一个组件
以新增加libuuid插件为例。当前版本根目录为/home/mpp/br_Gauss_OLAP_V100R005C00_MC2000
a. 确认当前新加插件的类型以及平台信息等。
   如：类型 binarylibs
	   平台信息 redhat6.4_x86_64
b. 在/home/mpp/br_Gauss_OLAP_V100R005C00_MC2000/binarylibs/redhat6.4_x86_64/目录下创建插装目录libuuid,
   libuuid目录下创建comm  debug  debug_llt  llt  release  release_llt六个目录
c. 在/home/mpp/br_Gauss_OLAP_V100R005C00_MC2000/3rd_src目录下新建目录“libuuid”，同时将第三方源码包libuuid-1.0.3.tar.gz 拷贝至libuuid目录
注意：任意两个插件的名称，其中一个不能是另一个的子集。
d. 在libuuid目录下创建config.ini文件和build.sh文件。
其中config.ini内容如下：
binarylibs@libuuid=comm|llt   
说明：
	  binarylibs								      -->插件类型
	  libuuid										  -->插件名插件名称(该名称同插装路径的名称需对应)
	  comm|llt										  -->编译参数说明，具体配置可参考1）说明
注意：不要重复配置一个插件，这样会导致筛选组件信息时异常错误。
build.sh文件说明。可依据已有其它插件的shell脚本进行修改。主要修改公共参数，以及build_component和shrink_component两个函数。
e. 将libuuid目录下config.ini的内容追加至3rd_src目录下的config.ini中
注意：不要重复配置一个插件，这样会导致筛选组件信息时异常错误。

