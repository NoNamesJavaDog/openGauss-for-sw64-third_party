## PostGIS概述

openGauss提供PostGIS Extension（版本为PostGIS-2.4.2）。PostGIS Extension是PostgreSQL的空间数据库扩展，提供如下空间信息服务功能：空间对象、空间索引、空间操作函数和空间操作符。PostGIS Extension完全遵循OpenGIS规范。



PostGIS安装
----------------------------------------------------------------------------

### 注意事项:

postgis扩展的安装高度依赖openGauss-third_party_binarylibs，你可以根据相应指导进行操作。
请注意，如果在没有构建的情况下使用提供的库，可能会出现“*找不到 xxxx.la*”等错误，在这种情况下，您需要将相应的文件复制到该目标。

### 安装准备:

Postgis插件依赖下列工具 (最低版本要求).

- **GCC-7.3. zlib.autoconf.automake**

- Geos 3.6.2

- Proj 4.9.2

- Json 0.12.1

- Libxml2 2.7.1

- Gdal 1.11.0

对于它们的安装，您可以自由选择自己安装，我们将只提供“*Geos.Proj.Json.Libxml.Gdal 1.11.0*”安装的脚本，您可以在之后选择通过脚本安装 “ ***GCC-7.3.zlib.autoconf.automake*** ”安装在环境中。

### 通过脚本编译安装：

1. 从网站下载源代码 *postgis-xc-master-2020-09-17.tar.gz*：

   https://opengauss.obs.cn-south-1.myhuaweicloud.com/dependency/postgis-xc-master-2020-09-17.tar.gz

2. 将其复制到 *$GAUSSHOME/ 路径，解压 tar.gz* 并重命名为 **postgis-xc**

3. 配置环境变量，根据代码下载位置添加***__\***。

   ```
   export CODE_BASE=________     # Path of the openGauss-server file
   export THIRDPARTY=________    # Path of the third-party file
   export BINARYLIBS=________    # Path of the binarylibs file
   export GAUSSHOME=________    # Path of opengauss installation
   export LD_LIBRARY_PATH=$GAUSSHOME/lib:$GAUSSHOME/install/geos/lib:$GAUSSHOME/install/proj4/lib:$GAUSSHOME/install/gdal/lib:$GAUSSHOME/install/libxml2/lib/:$LD_LIBRARY_PATH
   ```

4. 编译安装postgis: 

   ```
   cd $GAUSSHOME/postgis-xc
   然后按照"Compile and Install by Youself"选项执行
   ```

5. PostGIS 安装完成.

### 用户手动编译和安装:

1. 从网站下载源代码 postgis-xc-master-2020-09-17.tar.gz：
```shell
cd $GAUSSHOME
wget https://opengauss.obs.cn-south-1.myhuaweicloud.com/dependency/postgis-xc-master-2020-09-17.tar.gz
```
2. 解压，并重命名为 **postgis-xc**
```shell
cd $GAUSSHOME
tar -zxvf  postgis-xc-master-2020-09-17.tar.gz
mv postgis-xc-master  postgis-xc
```
3. 安装依赖工具。 如果您的系统是 **openeuler_aarch64**，请记住添加“*--build=aarch64-unknown-linux-gnu*”。 这些工具将安装在 *$GAUSSHOME/install* 目录下：

```shell
# 应用patch补丁
cd $GAUSSHOME/postgis-xc
# 由于raster插件相关的文件非Linux格式，所以在patch之前，需要先进行格式转换，若无dos2unix则先安装此工具
dos2unix postgis-2.4.2/postgis_raster--2.4.2.sql
patch -p1 < $THIRDPARTY/gpl_dependency/postgis/postgis_2.4.2-2.patch
# 如果使用含有dolphin插件的数据库进行postgis安装，还需要应用额外的dolphin补丁
patch -p1 < $THIRDPARTY/gpl_dependency/postgis/dolphin.patch

#复制依赖文件:
cp $THIRDPARTY/gpl_dependency/postgis/extension_dependency.h $GAUSSHOME/include/postgresql/server/

#安装 geos
cd $GAUSSHOME/postgis-xc/geos-3.6.2
chmod +x ./configure
./configure --prefix=$GAUSSHOME/install/geos
make -sj
make install -sj

#安装 proj
cd $GAUSSHOME/postgis-xc/proj-4.9.2
chmod +x ./configure
./configure --prefix=$GAUSSHOME/install/proj
make -sj
make install -sj

#安装 json
cd $GAUSSHOME/postgis-xc/json-c-json-c-0.12.1-20160607
chmod +x ./configure
./configure --prefix=$GAUSSHOME/install/json
make -sj
make install -sj

#安装 libxml2
cd $GAUSSHOME/postgis-xc/libxml2-2.7.1
chmod +x ./configure
./configure --prefix=$GAUSSHOME/install/libxml2
make -sj
make install -sj

#安装 gdal
cd $GAUSSHOME/postgis-xc/gdal-1.11.0
chmod +x ./configure
chmod +x ./install-sh
./configure --prefix=$GAUSSHOME/install/gdal --with-xml2=$GAUSSHOME/install/libxml2/bin/xml2-config --with-geos=$GAUSSHOME/install/geos/bin/geos-config --with-static_proj4=$GAUSSHOME/install/proj CFLAGS='-O2 -fpermissive -pthread'
make -sj
make install -sj

报错提示：
如果gdal编译失败，出现类似报错：
[by0314@s37 gdal-1.11.0]$ make -sj
/usr/bin/grep: /data/gcc2/target/gcc7.3/lib/../lib64/libstdc++.la: Permission denied
/usr/bin/sed: can't read /data/gcc2/target/gcc7.3/lib/../lib64/libstdc++.la: Permission denied
libtool: link: `/data/gcc2/target/gcc7.3/lib/../lib64/libstdc++.la' is not a valid libtool archive
make[1]: *** [GNUmakefile:41: libgdal.la] Error 1
make: *** [GNUmakefile:50: check-lib] Error 2
编译出现类似/data/gcc2/target/gcc7.3/lib/../lib64/libstdc++.la 找不到，可以自建目录，将libstdc++.la拷贝进去，然后再make -sj
（如果libstdc++.so出现类似问题，按同样方法处理）
如果gdal make时有除此之外的报错，可以尝试多次执行make -sj，还有问题可以尝试使用make -s

```

4. 安装 postgis，如果你的系统是 **openeuler_aarch64**，记得添加“*--build=aarch64-unknown-linux-gnu*”，并用你的系统类型补全“____”：

```
cd $GAUSSHOME/postgis-xc/postgis-2.4.2
sed -i -e 's/-Werror//g' $GAUSSHOME/lib/postgresql/pgxs/src/Makefile.global

#complile
./configure --prefix=$GAUSSHOME/install/pggis2.4.2 --with-pgconfig=$GAUSSHOME/bin/pg_config --with-projdir=$GAUSSHOME/install/proj --with-geosconfig=$GAUSSHOME/install/geos/bin/geos-config --with-jsondir=$GAUSSHOME/install/json \
                     --with-xml2config=$GAUSSHOME/install/libxml2/bin/xml2-config --with-raster --with-gdalconfig=$GAUSSHOME/install/gdal/bin/gdal-config --with-topology --without-address-standardizer \
                     CFLAGS='-O2 -fpermissive -DPGXC -pthread -D_THREAD_SAFE -D__STDC_FORMAT_MACROS -DMEMORY_CONTEXT_CHECKING -w' CC=g++

make -sj 
make install -sj

```
**注意：**
- 需要将 openGauss 缺少的头文件从其源码包中拷贝到数据库对应的 Include 目录下。
- 若出现 postgis_topology.c:249:54: error:base operand of '->' has non-pointer type  'FormData_pg_attribute' ...的报错，
  
  则将 postgis-2.4.2/topology/postgis_topology.c 下249行的最后一个箭头操作符“->”改为点操作符“.”，然后重新编译。
```cpp
  topo->geometryOID = SPI_tuptable->tupdesc->attrs[3]->atttypid;
```
改为：
```cpp
  topo->geometryOID = SPI_tuptable->tupdesc->attrs[3].atttypid;
```

5. 将文件复制到 opengauss 安装文件夹:

```
cp $GAUSSHOME/install/json/lib/libjson-c.so.2 $GAUSSHOME/lib/libjson-c.so.2
cp $GAUSSHOME/install/geos/lib/libgeos_c.so.1 $GAUSSHOME/lib/libgeos_c.so.1
cp $GAUSSHOME/install/proj/lib/libproj.so.9 $GAUSSHOME/lib/libproj.so.9
cp $GAUSSHOME/install/geos/lib/libgeos-3.6.2.so $GAUSSHOME/lib/libgeos-3.6.2.so
cp $GAUSSHOME/install/gdal/lib/libgdal.so.1.18.0 $GAUSSHOME/lib/libgdal.so.1
cp $GAUSSHOME/install/pggis2.4.2/lib/liblwgeom-2.4.so.0 $GAUSSHOME/lib/liblwgeom-2.4.so.0
cp $GAUSSHOME/postgis-xc/postgis-2.4.2/postgis.control $GAUSSHOME/share/postgresql/extension/
cp $GAUSSHOME/postgis-xc/postgis-2.4.2/postgis--2.4.2.sql $GAUSSHOME/share/postgresql/extension/

rm -f $GAUSSHOME/share/postgresql/extension/postgis_raster--2.*.sql
cp $GAUSSHOME/postgis-xc/postgis-2.4.2/postgis_raster--2.4.2.sql $GAUSSHOME/share/postgresql/extension/postgis_raster--2.4.2.sql
cp $GAUSSHOME/postgis-xc/postgis-2.4.2/postgis_raster.control $GAUSSHOME/share/postgresql/extension/postgis_raster.control

rm -f $GAUSSHOME/share/postgresql/extension/postgis_topology--2.*.sql
cp $GAUSSHOME/postgis-xc/postgis-2.4.2/extensions/postgis_topology/sql/postgis_topology--2.4.2.sql $GAUSSHOME/share/postgresql/extension/postgis_topology--2.4.2.sql
cp $GAUSSHOME/postgis-xc/postgis-2.4.2/extensions/postgis_topology/postgis_topology.control $GAUSSHOME/share/postgresql/extension/postgis_topology.control
```

# PostGIS使用

#### 创建Extension

创建PostGIS Extension可直接使用CREATE EXTENSION命令进行创建：
```sql
CREATE EXTENSION postgis;
```

使能PostGIS中的栅格功能，可直接使用CREATE  EXTENSION命令进行创建：
```sql
CREATE EXTENSION postgis_raster;
```

使能PostGIS中的拓扑功能，使用CREATE  EXTENSION命令进行创建之前先执行：
```sql
-- 使用CREATE  EXTENSION命令进行创建之前先执行
set behavior_compat_options='bind_procedure_searchpath';
CREATE EXTENSION postgis_topology;
```

#### 使用Extension

PostGIS Extension函数调用格式为：
```sql
SELECT GisFunction (Param1, Param2,......);
```

其中GisFunction为函数名，Param1、Param2等为函数参数名。

下列SQL语句展示PostGIS的简单使用，对于各函数的具体使用，请参考[《PostGIS-2.4.2用户手册》](https://download.osgeo.org/postgis/docs/postgis-2.4.2.pdf) 。

示例1：几何表的创建。
```sql
CREATE TABLE cities ( id integer, city_name varchar(50) );
SELECT AddGeometryColumn('cities', 'position', 4326, 'POINT', 2);
```

示例2：几何数据的插入。
```sql
INSERT INTO cities (id, position, city_name) VALUES (1,ST_GeomFromText('POINT(-9.5 23)',4326),'CityA');
INSERT INTO cities (id, position, city_name) VALUES (2,ST_GeomFromText('POINT(-10.6 40.3)',4326),'CityB');
INSERT INTO cities (id, position, city_name) VALUES (3,ST_GeomFromText('POINT(20.8 30.3)',4326), 'CityC');
```

示例3：计算三个城市间任意两个城市距离。
```sql
SELECT p1.city_name,p2.city_name,ST_Distance(p1.position,p2.position) FROM cities AS p1, cities AS p2 WHERE p1.id > p2.id;
```

#### 删除Extension

在GaussDB A中删除PostGIS Extension的方法如下所示：
```sql
DROP EXTENSION postgis [CASCADE];
```

如果Extension被其它对象依赖（如创建的几何表），需要加入CASCADE（级联）关键字，删除所有依赖对象。

若要完全删除PostGIS Extension，则需由omm用户使用gs_om工具移除PostGIS及其依赖的动态链接库，格式如下：

```shell
gs_om -t postgis -m rmlib
```

# PostGIS支持和限制

#### 支持数据类型

GaussDB A的PostGIS Extension支持如下数据类型:

- box2d
- box3d
- geometry_dump
- geometry
- geography
- raster



- 栅格相关的三个GUC参数postgis.gdal_datapath、postgis.gdal_enabled_drivers及postgis.enable_outdb_rasters内部已经完全使能，使用时不用再手动设置。
- 创建Postgis和使用Postgis不是同一个用户时，请设置如下guc参数：SET behavior_compat_options = 'bind_procedure_searchpath';

#### 支持的操作符和函数列表

表1 PostGIS Extension 支持的操作符和函数列表

| 函数分类                                                      | 包含函数                                                 |
| ----------------------------------------------------------- | ------------------------------------------------------------ |
| Management Functions                                        | AddGeometryColumn、DropGeometryColumn、DropGeometryTable、PostGIS_Full_Version、PostGIS_GEOS_Version、PostGIS_Liblwgeom_Version、PostGIS_Lib_Build_Date、PostGIS_Lib_Version、PostGIS_PROJ_Version、PostGIS_Scripts_Build_Date、PostGIS_Scripts_Installed、PostGIS_Version、PostGIS_LibXML_Version、PostGIS_Scripts_Released、Populate_Geometry_Columns 、UpdateGeometrySRID |
| Geometry Constructors                                       | ST_BdPolyFromText 、ST_BdMPolyFromText  、ST_Box2dFromGeoHash、ST_GeogFromText、ST_GeographyFromText、ST_GeogFromWKB、ST_GeomCollFromText、ST_GeomFromEWKB、ST_GeomFromEWKT、ST_GeometryFromText、ST_GeomFromGeoHash、ST_GeomFromGML、ST_GeomFromGeoJSON、ST_GeomFromKML、ST_GMLToSQL、ST_GeomFromText 、ST_GeomFromWKB、ST_LineFromMultiPoint、ST_LineFromText、ST_LineFromWKB、ST_LinestringFromWKB、ST_MakeBox2D、ST_3DMakeBox、ST_MakeEnvelope、ST_MakePolygon、ST_MakePoint、ST_MakePointM、ST_MLineFromText、ST_MPointFromText、ST_MPolyFromText、ST_Point、ST_PointFromGeoHash、ST_PointFromText、ST_PointFromWKB、ST_Polygon、ST_PolygonFromText、ST_WKBToSQL、ST_WKTToSQL |
| Geometry Accessors                                          | GeometryType、ST_Boundary、ST_CoordDim、ST_Dimension、ST_EndPoint、ST_Envelope、ST_ExteriorRing、ST_GeometryN、ST_GeometryType、ST_InteriorRingN、ST_IsClosed、ST_IsCollection、ST_IsEmpty、ST_IsRing、ST_IsSimple、ST_IsValid、ST_IsValidReason、ST_IsValidDetail、ST_M、ST_NDims、ST_NPoints、ST_NRings、ST_NumGeometries、ST_NumInteriorRings、ST_NumInteriorRing、ST_NumPatches、ST_NumPoints、ST_PatchN、ST_PointN、ST_SRID、ST_StartPoint、ST_Summary、ST_X、ST_XMax、ST_XMin、ST_Y、ST_YMax、ST_YMin、ST_Z、ST_ZMax、ST_Zmflag、ST_ZMin |
| Geometry Editors                                            | ST_AddPoint、ST_Affine、ST_Force2D、ST_Force3D、ST_Force3DZ、ST_Force3DM、ST_Force4D、ST_ForceCollection、ST_ForceSFS、ST_ForceRHR、ST_LineMerge、ST_CollectionExtract、ST_CollectionHomogenize、ST_Multi、ST_RemovePoint、ST_Reverse、ST_Rotate、ST_RotateX、ST_RotateY、ST_RotateZ、ST_Scale、ST_Segmentize、ST_SetPoint、ST_SetSRID、ST_SnapToGrid、ST_Snap、ST_Transform、ST_Translate、ST_TransScale |
| Geometry Outputs                                            | ST_AsBinary、ST_AsEWKB、ST_AsEWKT、ST_AsGeoJSON、ST_AsGML、ST_AsHEXEWKB、ST_AsKML、ST_AsLatLonText 、ST_AsSVG、ST_AsText、ST_AsX3D、ST_GeoHash |
| Operators                                                   | &&、&&&、&<、&<\|、&>、<<、<<\|、=、>>、@ 、\|&> 、\|>>、~、~=、<->、<#> |
| Spatial Relationships and Measurements                      | ST_3DClosestPoint、ST_3DDistance、ST_3DDWithin、ST_3DDFullyWithin、ST_3DIntersects、ST_3DLongestLine、ST_3DMaxDistance、ST_3DShortestLine、ST_Area、ST_Azimuth、ST_Centroid、ST_ClosestPoint、ST_Contains、ST_ContainsProperly、ST_Covers、ST_CoveredBy、ST_Crosses、ST_LineCrossingDirection、ST_Disjoint、ST_Distance、ST_HausdorffDistance、ST_MaxDistance、ST_DistanceSphere、ST_DistanceSpheroid、ST_DFullyWithin、ST_DWithin、ST_Equals、ST_HasArc、ST_Intersects、ST_Length、ST_Length2D、ST_3DLength、ST_Length_Spheroid、ST_Length2D_Spheroid、ST_3DLength_Spheroid、ST_LongestLine、ST_OrderingEquals、ST_Overlaps、ST_Perimeter、ST_Perimeter2D、ST_3DPerimeter、ST_PointOnSurface、ST_Project、ST_Relate、ST_RelateMatch、ST_ShortestLine、ST_Touches、ST_Within |
| Geometry Processing                                         | ST_Buffer、ST_BuildArea、ST_Collect、ST_ConcaveHull、ST_ConvexHull、ST_CurveToLine、ST_DelaunayTriangles、ST_Difference、ST_Dump、ST_DumpPoints、ST_DumpRings、ST_FlipCoordinates、ST_Intersection、ST_LineToCurve、ST_MakeValid、ST_MemUnion、ST_MinimumBoundingCircle、ST_Polygonize、ST_Node、ST_OffsetCurve、ST_RemoveRepeatedPoints、ST_SharedPaths、ST_Shift_Longitude、ST_Simplify、ST_SimplifyPreserveTopology、ST_Split、ST_SymDifference、ST_Union、ST_UnaryUnion |
| Linear Referencing                                          | ST_LineInterpolatePoint、ST_LineLocatePoint、ST_LineSubstring、ST_LocateAlong、ST_LocateBetween、ST_LocateBetweenElevations、ST_InterpolatePoint、ST_AddMeasure |
| Miscellaneous Functions                                     | ST_Accum、Box2D、Box3D、ST_Expand、ST_Extent、ST_3Dextent、Find_SRID、ST_MemSize |
| Exceptional Functions                                       | PostGIS_AddBBox、PostGIS_DropBBox、PostGIS_HasBBox           |
| Raster Management Functions                                 | AddRasterConstraints、DropRasterConstraints、AddOverviewConstraints、DropOverviewConstraints、PostGIS_GDAL_Version、PostGIS_Raster_Lib_Build_Date、PostGIS_Raster_Lib_Version、ST_GDALDrivers、UpdateRasterSRID |
| Raster Constructors                                         | ST_AddBand、ST_AsRaster、ST_Band、ST_MakeEmptyRaster、ST_Tile、ST_FromGDALRaster |
| Raster Accessors                                            | ST_GeoReference、ST_Height、ST_IsEmpty、ST_MetaData、ST_NumBands、ST_PixelHeight、ST_PixelWidth、ST_ScaleX、ST_ScaleY、ST_RasterToWorldCoord、ST_RasterToWorldCoordX、ST_RasterToWorldCoordY、ST_Rotation、ST_SkewX、ST_SkewY、ST_SRID、ST_Summary、ST_UpperLeftX、ST_UpperLeftY、ST_Width、ST_WorldToRasterCoord、ST_WorldToRasterCoordX、ST_WorldToRasterCoordY |
| Raster Band Accessors                                       | ST_BandMetaData、ST_BandNoDataValue、ST_BandIsNoData、ST_BandPath、ST_BandPixelType、ST_HasNoBand |
| Raster Pixel Accessors and Setters                          | ST_PixelAsPolygon、ST_PixelAsPolygons、ST_PixelAsPoint、ST_PixelAsPoints、ST_PixelAsCentroid、ST_PixelAsCentroids、ST_Value、ST_NearestValue、ST_Neighborhood、ST_SetValue、ST_SetValues、ST_DumpValues、ST_PixelOfValue |
| Raster Editors                                              | ST_SetGeoReference、ST_SetRotation、ST_SetScale、ST_SetSkew、ST_SetSRID、ST_SetUpperLeft、ST_Resample、ST_Rescale、ST_Reskew、ST_SnapToGrid、ST_Resize、ST_Transform |
| Raster Band Editors                                         | ST_SetBandNoDataValue、ST_SetBandIsNoData                    |
| Raster Band Statistics and Analytics                        | ST_Count、ST_CountAgg、ST_Histogram、ST_Quantile、ST_SummaryStats、ST_SummaryStatsAgg、ST_ValueCount |
| Raster Outputs                                              | ST_AsBinary、ST_AsGDALRaster、ST_AsJPEG、ST_AsPNG、ST_AsTIFF |
| Raster Processing                                           | ST_Clip、ST_ColorMap、ST_Intersection、ST_MapAlgebra、ST_Reclass、ST_Union、ST_Distinct4ma、ST_InvDistWeight4ma、ST_Max4ma、ST_Mean4ma、ST_Min4ma、ST_MinDist4ma、ST_Range4ma、ST_StdDev4ma、ST_Sum4ma、ST_Aspect、ST_HillShade、ST_Roughness、ST_Slope、ST_TPI、ST_TRI、Box3D、ST_ConvexHull、ST_DumpAsPolygons、ST_Envelope、ST_MinConvexHull、ST_Polygon、ST_Contains、ST_ContainsProperly、ST_Covers、ST_CoveredBy、ST_Disjoint、ST_Intersects、ST_Overlaps、ST_Touches、ST_SameAlignment、ST_NotSameAlignmentReason、ST_Within、ST_DWithin、ST_DFullyWithin |
| Raster Operators                                            | &&、&<、&>、=、@、~=、~                                      |

#### 空间索引

GaussDB A数据库的PostGIS Extension支持GIST (Generalized Search Tree) 空间索引（分区表除外）。相比于B-tree索引，GIST索引适应于任意类型的非常规数据结构，可有效提高几何和地理数据信息的检索效率。

使用如下命令创建GIST索引：

```sql
CREATE INDEX indexname ON tablename USING GIST ( geometryfield );
```

#### 扩展限制

- 只支持行存表；
- 不支持BRIN索引；
- spatial_ref_sys表在扩容期间只支持查询操作。

 
