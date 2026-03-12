open source target name £ºlibcgroup
source code repository : product warehouse
compile dependency: NULL
upgrade open source package method£º
----|pull command : python $(pwd)../../build/pull_open_source.py "path" "name" "id"
      |----path : the parent directory name
      |----name£ºthe package name in product warehouse
      |----id£ºpdm version id
the compile command : python build.py -m all -f libcgroup-0.41-21.el7.src.rpm -t "comm|llt"
Patch Info: 