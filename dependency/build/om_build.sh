#!/bin/bash

version_list=("7 8 9 10")
ORIGIN_PATH=${PATH}

for version in ${version_list};
do
   unset LD_LIBRARY_PATH
   export PYTHONHOME=/usr/local/python3${version}
   export LD_LIBRARY_PATH=$PYTHONHOME/lib:$LD_LIBRARY_PATH
   export PATH=$PYTHONHOME/bin:${ORIGIN_PATH}
   export DPYTHON_INCLUDE_PATH=$PYTHONHOME/include/python3.${version}
   echo "++++++++++++++++++++++++++++++++++++++$(python3 -V)++++++++++++++++++++++++++++++++++++++++++++"
   sh om_build_dependency.sh
   if [ $? != 0 ]; then
	   echo "om dependency build failed.....python version: $(python3 -V)"
       exit 1
   fi
 
done


