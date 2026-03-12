set -e
mkdir -p $(pwd)/../../output/install_tools
export TARGET_PATH=$(pwd)/../../output/install_tools
export LD_LIBRARY_PATH=$TARGET_PATH:$LD_LIBRARY_PATH:/usr/lib64
export PATH=$TARGET_PATH:$PATH
export PYTHONPATH=$TARGET_PATH:$LIBRARY_PATH

version_list=("3.6" "3.7" "3.8" "3.9" "3.10" "3.11")
python_version=`python3 -V | awk -F ' ' '{print $2}' | awk -F '.' -v OFS='.' '{print $1,$2}'`

TAR_SOURCE_FILE=v1.17.1.tar.gz
SOURCE_FILE=cffi-1.17.1
if [ -d ${SOURCE_FILE} ]; then
    rm -rf ${SOURCE_FILE}
fi
mkdir ${SOURCE_FILE}
tar -zxf $TAR_SOURCE_FILE -C $SOURCE_FILE --strip-components 1
cd $SOURCE_FILE
CFLAGS='-fstack-protector-all' LDFLAGS='-Wl,-z,relro,-z,now -z,noexecstack' python3 setup.py build
PYTHONHASHSEED=0 python3 setup.py install --user

cp -r build/lib*/* $TARGET_PATH

for version in ${version_list[@]}
do
    if [ $version == $python_version  ]; then
        mkdir -p $TARGET_PATH/_cffi_backend_${version}
        mv $TARGET_PATH/_cffi_backend.*.so $TARGET_PATH/_cffi_backend.so
        cp $TARGET_PATH/_cffi_backend.so  $TARGET_PATH/_cffi_backend_${version}/
        cp $TARGET_PATH/_cffi_backend_${version}/_cffi_backend.so $TARGET_PATH/_cffi_backend.so_UCS4_$python_version
        break
    fi
done
