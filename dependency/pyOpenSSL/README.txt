open source target name: pyopnenSSL
source code repository: pyOpenSSL-19.0.0.tar.gz
compile dependency: cryptography
upgrade open source package method:
----|pull command: python $(pwd)../../build/pull_open_source.py "pyopnenSSL" "pyOpenSSL-19.0.0.tar.gz" "05833EMP"
      |----path: the parent directory name
      |----name: the package name in product warehouse
      |----id: pdm version id
the compile command: sh build.sh
Patch Info:
backup:
