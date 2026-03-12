需要预先编译好protobuf(当前版本在gcc4.8下面编译), openssl 并保持编译好的目录结构不变。

1、解压缩grpc压缩包，打patch
cd ~/XuanYuan/open_source/grpc
tar zxvf grpc-1.18.0.tar.gz
cd grpc-1.18.0/
patch -p1 < ../huawei_grpc-1.18.0.patch

2 ~/ XuanYuan/open_source/protobuf/install_comm/bin加到环境变量PATH里面，为了找了protoc程序

3、建立pkgconfig，复制openssl编译结果pkgconfig文件夹下*.pc文件至pkgconfig下。检查*.pc文件中，描述路径是否正确。
cd ~/XuanYuan/open_source/grpc
mkdir pkgconfig
cd pkgconfig
cp ~/XuanYuan/open_source /protobuf/protobuf-3.1.0/lib/pkgconfig/*.pc ./pkgconfig/

4、替换grpc-1.8.6/third_party/cares/cares/ 为c-ares 1.13.0
cd ~/XuanYuan/open_source/c-ares
tar zxvf c-ares-1.13.0.tar.gz
cd ~/XuanYuan/open_source/grpc/grpc-1.18.0/third_party/cares
rm -rf ./cares
cp ~/XuanYuan/open_source/c-ares/c-ares-1.13.0/ cares/ -rf
rm ./cares/ares_build.h

5、编译grpc
export PKG_CONFIG_PATH= ~/XuanYuan/open_source/grpc/pkgconfig
cd ~/XuanYuan/open_source/grpc/grpc-1.18.0

注
这样编译出来的文件是会对protobuf.so有依赖的，但是我们的安装库里面没有带protobuf.so，所以采取静态依赖，
修改Makefile如下，然后进行步骤5
-LIBS_PROTOBUF =  ~/XuanYuan/open_source/protobuf/install_comm/lib/libprotobuf.a
-LIBS_PROTOC =  ~/XuanYuan/open_source/protobuf/install_comm/lib/libprotoc.a ~/XuanYuan/open_source/protobuf/install_comm/lib/libprotobuf.a
+LIBS_PROTOBUF = protobuf
+LIBS_PROTOC = protoc protobuf

-HOST_LDLIBS_PROTOC += $(LIBS_PROTOC)
+HOST_LDLIBS_PROTOC += $(addprefix -l, $(LIBS_PROTOC))

 ifeq ($(PROTOBUF_PKG_CONFIG),true)
 -LDLIBS_PROTOBUF += $(shell $(PKG_CONFIG) --libs-only-l ~/XuanYuan/open_source/protobuf/install_comm/lib/libprotobuf.a)
 +LDLIBS_PROTOBUF += $(shell $(PKG_CONFIG) --libs-only-l protobuf)
  else
  -LDLIBS_PROTOBUF += $(LIBS_PROTOBUF)
  +LDLIBS_PROTOBUF += $(addprefix -l, $(LIBS_PROTOBUF))

