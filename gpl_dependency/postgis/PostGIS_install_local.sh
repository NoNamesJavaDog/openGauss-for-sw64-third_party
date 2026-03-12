#!/bin/bash

postgis_dir=`cd $(dirname $0); pwd`;
gplsrc_dir=$postgis_dir/gplsrc

cp $GAUSSHOME/install/json/lib/libjson-c.so.2 $GAUSSHOME/lib/libjson-c.so.2
cp $GAUSSHOME/install/geos/lib/libgeos_c.so.1 $GAUSSHOME/lib/libgeos_c.so.1
cp $GAUSSHOME/install/proj/lib/libproj.so.9 $GAUSSHOME/lib/libproj.so.9
cp $GAUSSHOME/install/geos/lib/libgeos-3.6.2.so $GAUSSHOME/lib/libgeos-3.6.2.so
cp $GAUSSHOME/install/gdal/lib/libgdal.so.1.18.0 $GAUSSHOME/lib/libgdal.so.1
cp $GAUSSHOME/install/pggis2.4.2/lib/liblwgeom-2.4.so.0 $GAUSSHOME/lib/liblwgeom-2.4.so.0

cd $gplsrc_dir/postgis-2.4.2

cp postgis--2.4.2.sql $GAUSSHOME/share/postgresql/extension/postgis--2.4.2.sql
cp postgis.control $GAUSSHOME/share/postgresql/extension/postgis.control

rm -f $GAUSSHOME/share/postgresql/extension/postgis_raster--2.*.sql
cp postgis_raster--2.4.2.sql $GAUSSHOME/share/postgresql/extension/postgis_raster--2.4.2.sql
cp postgis_raster.control $GAUSSHOME/share/postgresql/extension/postgis_raster.control

rm -f $GAUSSHOME/share/postgresql/extension/postgis_topology--2.*.sql
cp ./extensions/postgis_topology/sql/postgis_topology--2.4.2.sql $GAUSSHOME/share/postgresql/extension/postgis_topology--2.4.2.sql
cp ./extensions/postgis_topology/postgis_topology.control $GAUSSHOME/share/postgresql/extension/postgis_topology.control
