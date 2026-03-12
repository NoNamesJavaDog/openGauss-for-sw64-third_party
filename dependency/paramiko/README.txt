open source target name: paramiko
source code repository: paramiko-2.6.0.tar.gz
compile dependency: linux platform(bcrypt, cryptography, pynacl, cffi, enum34, ipaddress, six), windows platform (gssapi, pywin32, .etc)
upgrade open source package method:
----|pull command: python $(pwd)../../build/pull_open_source.py "paramiko" "paramiko-2.6.0.tar.gz" "05833MWY"
      |----path: the parent directory name
      |----name: the package name in product warehouse
      |----id: pdm version id
the compile command: sh build.sh
Patch Info:
backup:
