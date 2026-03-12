open source target name ：libcurl
source code repository : product warehouse
compile dependency: openssl, kerberos, zlib
upgrade open source package method：
----|pull command : python $(pwd)../../build/pull_open_source.py "path" "name" "id"
      |----path : the parent directory name
      |----name：the package name in product warehouse
      |----id：pdm version id
the compile command : sh ./build.sh
Patch Info: 

Backup:
binarylibs\XXX\libetcdapi\comm\lib目录下的libetcd.so依赖于libcurl组件，并且要求libcurl支持ssl协议，即支持HTTPS，
(curl默认支持HTTP,不支持HTTPS)

curl组件编译简要步骤：
(1) 设置环境变量LD_LIBRARY_PATH, 指定ssl库路径(使用代码大包中自带的ssl)，则可以支持ssl协议
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/代码目录/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/openssl/comm/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/代码目录/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/zlib1.2.11/comm/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/代码目录/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/kerberos/comm/lib
注意：/代码目录/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/openssl/comm/lib 要换成自己的代码路径，目录要写到lib这一级

(2) 设置环境变量C_INCLUDE_PATH，指定头文件路径
export C_INCLUDE_PATH=$C_INCLUDE_PATH::/代码目录/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/kerberos/comm/INCLUDE

(3) 解压缩tar包
tar -zxvf curl-7.64.0.tar.gz

(4) 把补丁代码合入curl代码中，准备编译
patch -p0 < huawei_curl-7.64.0.patch
如果本次有新增的补丁代码（huawei_curl-7.64.0.patch中没有包含），请 vi 编辑对应的代码文件，把补丁代码手工改进去。

(5) 进入解压后的curl目录，进行configure配置
cd curl-7.64.0

./configure --prefix=/home/用户名/curl --with-ssl=ssl目录  --without-libssh2 CFLAGS='-fstack-protector-strong -Wl,-z,relro,-z,now' --with-zlib=zlib目录 --with-gssapi_krb5_gauss-includes=gssapi_krb5_gauss/include目录 --with-gssapi_krb5_gauss-libs=gssapi_krb5_gauss/lib目录
此处用户名换成自己的用户，ssl/zlib/gssapi_krb5_gauss目录设置为代码中自带的ssl、zlib、gssapi_krb5_gauss/include、ssapi_krb5_gauss/lib目录，例如：/代码目录/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/openssl/comm
注意，这里的ssl/zlib目录要写到comm 这一级，和第(1)步中的lib 不一样。

示例：
./configure --prefix=/home/用户名/curl --with-ssl=/代码目录/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/openssl/comm --without-libssh2 CFLAGS='-fstack-protector-strong -Wl,-z,relro,-z,now' --with-zlib=/代码目录/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/zlib1.2.11/comm --with-gssapi_krb5_gauss-includes=/代码目录/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/kerberos/comm/include --with-gssapi_krb5_gauss-libs=/代码目录/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/kerberos/comm/lib
注： CFLAGS='-fstack-protector-strong -Wl,-z,relro,-z,now ' 是安全编译选项

configure最终结果：
configure: Configured to build curl/libcurl:

  curl version:     7.64.0
  SSL support:      enabled (OpenSSL)
  SSH support:      no      (--with-libssh2)
  zlib support:     enabled
  brotli support:   no      (--with-brotli)
  GSS-API support:  enabled (MIT Kerberos/Heimdal)
  TLS-SRP support:  enabled
  resolver:         POSIX threaded
  IPv6 support:     enabled
  Unix sockets support: enabled
  IDN support:      no      (--with-{libidn2,winidn})
  Build libcurl:    Shared=yes, Static=yes
  Built-in manual:  enabled
  --libcurl option: enabled (--disable-libcurl-option)
  Verbose errors:   enabled (--disable-verbose)
  Code coverage:    disabled
  SSPI support:     no      (--enable-sspi)
  ca cert bundle:   /etc/pki/tls/certs/ca-bundle.crt
  ca cert path:     no
  ca fallback:      no
  LDAP support:     no      (--enable-ldap / --with-ldap-lib / --with-lber-lib)
  LDAPS support:    no      (--enable-ldaps)
  RTSP support:     enabled
  RTMP support:     no      (--with-librtmp)
  metalink support: no      (--with-libmetalink)
  PSL support:      no      (libpsl not found)
  HTTP2 support:    disabled (--with-nghttp2)
  Protocols:        DICT FILE FTP FTPS GOPHER HTTP HTTPS IMAP IMAPS POP3 POP3S RTSP SMB SMBS SMTP SMTPS TELNET TFTP
 
(6) 编译生成lib 
make
make install

(8)最后切换到/home/用户名/curl/lib目录下验证编译好的二进制文件是否已经支持HTTPS协议。
ldd libcurl.so显示依赖 libssl.so.1.1，如下

[chenxin@linux-z8tq lib]$ ldd libcurl.so
        linux-vdso.so.1 =>  (0x0000ffff80ab0000)
        libssl.so.1.1 => /home/chenxin/r8c10/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/openssl/comm/lib/libssl.so.1.1 (0x0000ffff80910000)
        libcrypto.so.1.1 => /home/chenxin/r8c10/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/openssl/comm/lib/libcrypto.so.1.1 (0x0000ffff80620000)
        libgssapi_krb5_gauss.so.2 => /home/chenxin/r8c10/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/kerberos/comm/lib/libgssapi_krb5_gauss.so.2 (0x0000ffff805b0000)
        libkrb5_gauss.so.3 => /home/chenxin/r8c10/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/kerberos/comm/lib/libkrb5_gauss.so.3 (0x0000ffff804c0000)
        libk5crypto_gauss.so.3 => /home/chenxin/r8c10/GAUSS200_OLAP_TRUNK/binarylibs/suse11_sp1_x86_64/comm/lib/libk5crypto_gauss.so.3  (0x0000ffff80470000)
        libcom_err_gauss.so.3 => /home/chenxin/r8c10/GAUSS200_OLAP_TRUNK/binarylibs//comm/lib/suse11_sp1_x86_64/kerberos/comm/lib/libcom_err_gauss.so.3 (0x0000ffff80440000)
        libz.so.1 => /usr/local/lib/libz.so.1 (0x0000ffff803e0000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x0000ffff803a0000)
        libc.so.6 => /lib64/libc.so.6 (0x0000ffff80210000)
        /lib/ld-linux-aarch64.so.1 (0x0000ffff80ac0000)
        libdl.so.2 => /lib64/libdl.so.2 (0x0000ffff801e0000)
        libkrb5support_gauss.so.0 => /home/chenxin/r8c10/GAUSS200_OLAP_TRUNK/binarylibs/redhat6.4_aarch64/kerberos/comm/lib/libkrb5support_gauss.so.0 (0x0000ffff801b0000)
        libkeyutils.so.1 => /lib64/libkeyutils.so.1 (0x0000ffff80180000)
        libresolv.so.2 => /lib64/libresolv.so.2 (0x0000ffff80140000)

(7) 将/home/用户名/curl/lib目录下的libcurl.a， libcurl.so.4.5.0 文件复制到代码的如下目录：
(libcurl与操作系统平台无关，所以编译的libcurl.so文件redhat，suse等通用，libcurl.la文件就不要复制了，该文件是文本文件，运行用不到)
GAUSS200_OLAP_TRUNK\binarylibs\redhat6.4_x86_64\libcurl\comm\lib
GAUSS200_OLAP_TRUNK\binarylibs\suse11_sp1_x86_64\libcurl\comm\lib
GAUSS200_OLAP_TRUNK\binarylibs\suse12_x86_64\libcurl\comm\lib
同时把libcurl.so.4.5.0复制两份，分别改名为libcurl.so.4和 libcurl.so


(8) 把新增的补丁代码加入到huawei_curl-7.64.0.patch中归档
用如下命令生成补丁差异代码，前面目录是老代码，后面目录是打补丁的新代码，把生成的差异追加到huawei_curl-7.64.0.patch文件末尾。

diff -Naru curl-7.64.0/lib/tftp.c curl/curl-7.64.0/lib/tftp.c
--- curl-7.64.0/lib/tftp.c  2019-01-26 07:29:47.000000000 +0800
+++ curl/curl-7.64.0/lib/tftp.c      2019-06-17 17:44:44.470111260 +0800
@@ -1005,7 +1005,7 @@
   state->sockfd = state->conn->sock[FIRSTSOCKET];
   state->state = TFTP_STATE_START;
   state->error = TFTP_ERR_NONE;
-  state->blksize = TFTP_BLKSIZE_DEFAULT;
+  state->blksize = blksize;
   state->requested_blksize = blksize;

   ((struct sockaddr *)&state->local_addr)->sa_family =
