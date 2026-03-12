open source target name: python
source code repository: x86(Python-2.7.5.tgz), ARM(python_2.7.16_src.zip)
compile dependency: NUL
upgrade open source package method:
----|pull command: python $(pwd)../../build/pull_open_source.py "bcrypt" "bcrypt-3.1.7.tar.gz" "05833LMP"
      |----path: the parent directory name
      |----name: the package name in product warehouse
      |----id: pdm version id
the compile command: sh build.sh
Patch Info:
backup: 
