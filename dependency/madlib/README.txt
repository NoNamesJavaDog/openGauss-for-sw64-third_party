## Introduction

 This module contains the  implementation patch and installation scripts for "MADlib", which support AI in DB in openGauss.  Currently, openGauss supports machine learning algorithm in  MADlib17. 



## Before Installation

Madlib relies on plpython2. So, we must compile GaussDB with python.

#### Check Python Environment

python version must >= 2.7.12, we highly recommend 2.7.17 or 2.7.18

1)  if your python version >= 2.7.12, you can install `yum install python-devel`, others, please goto step 2.

2) install python2.7.18 by yourself with '**--enable-shared**' option when configure.

	```
	./configure --prefix=YOUR_XXX --enable-shared --enable-unicode=ucs4
	make -sj;make install -sj
	```



#### Re-compile Database

Compile openGauss, with '**--with-python**' option when configure.



Installation MADlib
 ----------------------------------------------------------------------------


 ### Compile

 1. patch MADlib.
	```
	tar -zxf apache-madlib-1.17.0-src.tar.gz
	cp madlib.patch apache-madlib-1.17.0-src
	cd apache-madlib-1.17.0-src/
	patch -p1 < madlib.patch
	```

 2. compile MADlib:
    **MADlib will download dependent software while compiling.**
    1. If your machine can connect to Internet.
		you can run:
	```
	./configure -DCMAKE_INSTALL_PREFIX={YOUR_MADLIB_INSTALL_FOLDER}            # your install folder
	-DPOSTGRESQL_EXECUTABLE=$GAUSSHOME/bin/ 
	-DPOSTGRESQL_9_2_EXECUTABLE=$GAUSSHOME/bin/ 
	-DPOSTGRESQL_9_2_CLIENT_INCLUDE_DIR=$GAUSSHOME/bin/ 
	-DPOSTGRESQL_9_2_SERVER_INCLUDE_DIR=$GAUSSHOME/bin/
	make && make install -sj
    ```
    
    2. If your machine cannot download dependcy online.
		you must download Dependent Software by yourself.

	  - PyXB-1.2.6.tar.gz,   http://sourceforge.net/projects/pyxb/files/PyXB-1.2.6.tar.gz
	  - eigen-branches-3.2.tar.gz, https://github.com/madlib/eigen/archive/branches/3.2.tar.gz
	  - boost_1_61_0.tar.gz

    ```
    	./configure -DCMAKE_INSTALL_PREFIX={YOUR_MADLIB_INSTALL_FOLDER}            # your install folder
    	-DPYXB_TAR_SOURCE={YOUR_DEPENDENCY_FOLDER}/PyXB-1.2.6.tar.gz               # change to your local folder 
    	-DEIGEN_TAR_SOURCE={YOUR_DEPENDENCY_FOLDER}/eigen-branches-3.2.tar.gz      # change to your local folder 
    	-DBOOST_TAR_SOURCE={YOUR_DEPENDENCY_FOLDER}/boost_1_61_0.tar.gz            # change to your local folder 
    	-DPOSTGRESQL_EXECUTABLE=$GAUSSHOME/bin/ 
    	-DPOSTGRESQL_9_2_EXECUTABLE=$GAUSSHOME/bin/ 
    	-DPOSTGRESQL_9_2_CLIENT_INCLUDE_DIR=$GAUSSHOME/bin/ 
    	-DPOSTGRESQL_9_2_SERVER_INCLUDE_DIR=$GAUSSHOME/bin/
    	make && make install -sj
    ```

 3. Finished


 ### Install MADlib

 #### install python package

some algorithm depends on python package.

```
 pip install numpy==1.14.5
 pip install pandas==0.24.2
 pip install scipy
```

gsql connects to your database.


```
create database <YOUR_DATABASE> dbcompatibility='B';
```

```
cd {YOUR_MADLIB_INSTALL_FOLDER}
./madpack -s <YOUR_SCHEMA> -p opengauss -c <DATABASE_USERNAME>@127.0.0.1:<PORT>/<YOUR_DATABASE> install
```

#### Additional software

 1) if you use facebook prophet 

```
pip install pystan
pip install holidays==0.9.8
pip install fbprophet==0.3.post2
```

 2) if you use xgboost

```
pip install xgboost
pip install scikit-learn
```

 #### Primary/secondary

 Your need to copy python and `{YOUR_MADLIB_INSTALL_FOLDER}` to the same path in secondary machine.
