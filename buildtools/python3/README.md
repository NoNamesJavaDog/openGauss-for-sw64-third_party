### 编译Python3

#### 背景

针对于openEuler操作系统，系统默认的openssl版本是1.1.1d。由于该版本存在漏洞，openGauss主干升级openssl到1.1.1g。而三方库编译使用的openssl版本为1.1.1g。
两个openssl版本以及系统提供python的兼容性问题，导致了OM安装在建立互信时候出现异常。错误如下：
```
Are you sure you want to create trust for root (yes/no)? yes
Please enter password for root.
Password:
Creating SSH trust for the root permission user.
Traceback (most recent call last):
  File "/root/gauss_om/omm/script/gs_sshexkey", line 45, in <module>
    import paramiko
  File "/root/gauss_om/omm/script/gspylib/common/../../../lib/paramiko/__init__.py", line 22, in <module>
    from paramiko.transport import SecurityOptions, Transport
  File "/root/gauss_om/omm/script/gspylib/common/../../../lib/paramiko/transport.py", line 129, in <module>
    class Transport(threading.Thread, ClosingContextManager):
  File "/root/gauss_om/omm/script/gspylib/common/../../../lib/paramiko/transport.py", line 190, in Transport
    if KexCurve25519.is_available():
  File "/root/gauss_om/omm/script/gspylib/common/../../../lib/paramiko/kex_curve25519.py", line 30, in is_available
    X25519PrivateKey.generate()
  File "/root/gauss_om/omm/script/gspylib/common/../../../lib/cryptography/hazmat/primitives/asymmetric/x25519.py", line 38, in generate
    from cryptography.hazmat.backends.openssl.backend import backend
  File "/root/gauss_om/omm/script/gspylib/common/../../../lib/cryptography/hazmat/backends/openssl/__init__.py", line 7, in <module>
    from cryptography.hazmat.backends.openssl.backend import backend
  File "/root/gauss_om/omm/script/gspylib/common/../../../lib/cryptography/hazmat/backends/openssl/backend.py", line 75, in <module>
    from cryptography.hazmat.bindings.openssl import binding
  File "/root/gauss_om/omm/script/gspylib/common/../../../lib/cryptography/hazmat/bindings/openssl/binding.py", line 16, in <module>
    from cryptography.hazmat.bindings._openssl import ffi, lib
ImportError: /root/gauss_om/omm/script/gspylib/common/../../../lib/cryptography/hazmat/bindings/_openssl.so: symbol SSLv3_method version OPENSSL_1_1_0 not defined in file libssl.so.1.1 with link time reference
```
（对于其他系统，如果也存在openssl版本低导致的OM安装出现以上问题，也可以使用该解决方案）

解决方案如下：

1. 您可以在所有需要安装数据库的openEuler的系统上，使用高版本的openssl重新编译和安装Python3
2. 仅在编译三方库的机器上重新编译Python3，将编译完成后OM安装依赖的libpython3.*m.so.1.0文件拷贝到三方库对应目录，使用此三方库编译openGauss-OM和openGauss-server。数据库安装的系统上便不用做重新编译Python的操作了。

第2步的操作步骤如下：

#### 编译Python步骤

1. 首先编译好源码中的openssl，`build`目录下执行`sh build_all.sh`即可。编译完成后目标目录在`output/dependency/${PLATFORM}/openssl`下。如下的编译Python依赖此openssl编译结果。

2. 源码中已经提供好了编译Python的脚本，在`buildtools/python3`目录下，执行`sh build.sh`脚本即可。完成后，会将需要的文件复制到 `output/dependency/install_tools_${PLATFORM}/`下。

#### 注意事项

上一步中，编译python3时候，会将编译结果写入到系统的`/usr`目录，这样会对已有的`lib lib64`等目录中的python库进行覆盖。如果在编译机器上有运行python相关的业务，请评估下影响。