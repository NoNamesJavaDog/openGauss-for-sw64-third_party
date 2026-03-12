open source target name £ºkerberos
source code repository : product warehouse
compile dependency: NULL
upgrade open source package method£º
----|pull command : python $(pwd)../../build/pull_open_source.py "path" "name" "id"
      |----path : the parent directory name
      |----name£ºthe package name in product warehouse
      |----id£ºpdm version id
the compile command : python build.py -m all -f krb5-1.17.1.tar.gz -t "comm|llt"
Patch Info: 