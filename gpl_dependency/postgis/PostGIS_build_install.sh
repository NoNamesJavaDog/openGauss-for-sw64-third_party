postgis_dir=`cd $(dirname $0); pwd`;
gplsrc_dir=$postgis_dir/gplsrc
bundle_file="${postgis_dir}/postgis-bundle.tar.bz2"

test -d ${gplsrc_dir} || mkdir ${gplsrc_dir}
if [ -f $bundle_file ]; then
    rm -fr ${gplsrc_dir}/*
    tar -C ${gplsrc_dir} -xjf $bundle_file
fi

if [ $(uname -m) = "aarch64" ]; then 
    build_type="--build=aarch64-unknown-linux-gnu"
fi

#(1)
cd $gplsrc_dir/geos-3.6.2
chmod +x ./configure
./configure  ${build_type} --prefix=$GAUSSHOME/install/geos
make -sj
if [ $? != 0 ]; then
echo "ERROR: Failed to build geos."
exit 1
fi
make install

#(2)
cd $gplsrc_dir/proj-4.9.2
chmod +x ./configure
./configure --prefix=$GAUSSHOME/install/proj
make -sj
if [ $? != 0 ]; then
echo "ERROR: Failed to build proj."
exit 1
fi
make install 

#(3)
cd $gplsrc_dir/json-c-json-c-0.12.1-20160607
chmod +x ./configure
./configure --prefix=$GAUSSHOME/install/json
touch aclocal.m4
touch Makefile.in
touch config.h.in
touch configure
touch Makefile
make -sj
if [ $? != 0 ]; then
echo "ERROR: Failed to build json-c."
exit 1
fi
make install 

#(4)
cd $gplsrc_dir/libxml2-2.7.1
chmod +x ./configure
./configure ${build_type} --prefix=$GAUSSHOME/install/libxml2
make -sj
if [ $? != 0 ]; then
echo "ERROR: Failed to build libxml2."
exit 1
fi
make install 

#(5)
cd $gplsrc_dir/gdal-1.11.0
chmod +x ./configure
chmod +x ./install-sh
./configure ${build_type} --prefix=$GAUSSHOME/install/gdal --with-xml2=$GAUSSHOME/install/libxml2/bin/xml2-config --with-geos=$GAUSSHOME/install/geos/bin/geos-config --with-static_proj4=$GAUSSHOME/install/proj CFLAGS='-O2 -fpermissive -pthread'
make -sj
make || make
if [ $? != 0 ]; then
echo "ERROR: Failed to build gdal."
exit 1
fi
make install 


#(-1)
cd $gplsrc_dir/postgis-2.4.2
cp $postgis_dir/../extension_dependency.h $GAUSSHOME/include/postgresql/server/extension_dependency.h
cp $GAUSSHOME/lib/postgresql/pgxs/src/Makefile.global $GAUSSHOME/lib/postgresql/pgxs/src/Makefile.global.$(date +%Y%m%d%H%M)
sed -i -e 's/-Werror//g' $GAUSSHOME/lib/postgresql/pgxs/src/Makefile.global
patch -p5 < $postgis_dir/postgis_2.4.2-1.patch
chmod +x ./configure
./configure --prefix=$GAUSSHOME/install/pggis2.4.2 --with-pgconfig=$GAUSSHOME/bin/pg_config --with-projdir=$GAUSSHOME/install/proj --with-geosconfig=$GAUSSHOME/install/geos/bin/geos-config --with-jsondir=$GAUSSHOME/install/json --with-xml2config=$GAUSSHOME/install/libxml2/bin/xml2-config --with-raster --with-gdalconfig=$GAUSSHOME/install/gdal/bin/gdal-config --with-topology --without-address-standardizer CFLAGS='-O2 -fpermissive -DPGXC -pthread -D_THREAD_SAFE -D__STDC_FORMAT_MACROS -DMEMORY_CONTEXT_CHECKING -w' CC=g++

make -sj
make install -sj

sh $postgis_dir/PostGIS_install_local.sh
