open source target name : jemalloc
source code repository : product warehouse
compile dependency: NULL
upgrade open source package method:
----|pull command : python $(pwd)../../build/pull_open_source.py "path" "name" "id"
      |----path : the parent directory name
      |----name : the package name in product warehouse
      |----id : pdm version id
the compile command : python build.py -m all -f jemalloc-5.3.0.tar.bz2 -t "release|debug"
Patch Info: 