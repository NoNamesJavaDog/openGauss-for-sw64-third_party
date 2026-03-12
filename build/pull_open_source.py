#!/usr/bin/env python
# coding=utf-8
# description: Python script for open source software getting from open source central repository.
# Copyright (c) 2020 Huawei Technologies Co.,Ltd.
# date: 2020-06-17

#-------------------------------------------------------------------------#
#usage:                                                                   #
#   python3/python pull_open_source.py -m center                          #
#   -m: build mode include center|github                                  #
#-------------------------------------------------------------------------#

exit(0)

import os
import subprocess
import sys
import argparse

#--------------------------------------------------------#
# open source software build operator                    #
#--------------------------------------------------------#

class OPOperator():
    def __init__(self):
        self.local_dir = os.getcwd()

#--------------------------------------------------------#
# pull source code from center repository                #
#--------------------------------------------------------#

    def pull_from_center(self, folder_name, package_name, PDMCode):
        PDM_token = "ETMsDgAAAW3y4VWSABRBRVMvQ0JDL1BLQ1M1UGFkZGluZwCAABAAEHdISqnBxYC1s+zZWobYBFQAAAJwG6/R2TxjSoAFn5ZgE2+0G34uQQrJiT4u6yWZCy30oAr42jaJxSVzu9yTpqMYOWB3mwbp8Uq0bRHOKejexrkFeB1oLloo5BJNIVKmQjI71wSg7e9NJesnYn7XdT2wRAxrK1aFyftpUyY0wcW9QWe4oWnRVBFyzelqen67xFqsHOKz3kaau0UpkJpUxXSWhAi/wMTgTky4YeQfv03xSx7JKFuh4JiBrd+OKf78AHYhN69CxzQYWcesg25k10gqZZwHCTTHfni3C+7rgXo61Dc4lAuiuwpf+eD0LBgZuN8gD0+aI+0asx8ZGasNJms6Rblq1/Ai7mhnC130hKJr2yonP89D40zzjLpyiXu7Eil4Kmhu4KBdq/ATuXZVnPY83lJnMR0HLmlx+ZjL4+HsSR2ag5JzaNcIuYUqpIyfToUHjCVpxwTNTZj4pCPGmOB0mzVwrkUqG7M/WwA0D/z8XDzy6A7GcFlUzSIeARf3bFOsgqYEiV4GdnCMdo00A2Q2oBlsI1/zlbt7DIwpO6Rc5K9t3CfEYF++xx86Pwn8AwdFZ+5U9uFcQ9nsMxNwtzoRJnDrlVgGnhtRshbVtNvB7p8zSxpoayzVI6hYtPRDp4K6CqT32H5UNcsnAxne5J+BekOd9kfc4eltIpqyfIgWkIIwq1NUv/uKjqx4L3ZK45DZl/HG7wSZmI2dKGBBIxZKJc3QuNPVUg2Bs8TumCUH1glr+BJmYSNoqSLGH9jjHwn6gPXaXUjuhzO5Mtc07G59uSnCVnsBqcL4uWLh6vr2afkAKBapIa7QK0VYuOu4MZk3A7hIK+yFcnjtExTgC2ZnLOWMABRoMUXYuJBErTud8ZnarXdTImMliQ=="
        print ("[INFO] Download open source software from center")
        rm_cmd = 'cd %s/../%s; rm -rf %s' % (self.local_dir, folder_name, package_name)
        ret = self.exe_cmd(rm_cmd)
        self.error_handler(ret)
        print ("[INFO] start download new package: %s" % (package_name))
        download_cmd = 'cd %s/../%s; curl -o "%s" -k -H "x-auth-token: "%s"" "https://svr.centralrepo.inhuawei.com/cmc-oss/v1/opensource/download?softVersionId="%s"&packages="%s"&fromPage=true"' % (self.local_dir, folder_name, package_name, PDM_token, PDMCode, package_name)
        ret = self.exe_cmd(download_cmd)
        self.error_handler(ret)

#--------------------------------------------------------#
# get open source from center                            #
#--------------------------------------------------------#

    def pull_center_test(self):
        #fio pull
        self.pull_from_center('fio', 'fio-fio-3.8.tar.gz', '05832WND')
        #iperf pull
        self.pull_from_center('iperf', 'iperf-3.7.tar.gz', '05833PNC')
        #kafka python pull
        self.pull_from_center('kafka-python', 'kafka-python-2.0.0.tar.gz', '05835PPS')
        #jackson pull
        self.pull_from_center('jackson', 'jackson-annotations-2.11.2.jar', '05836QJR')
        #jackson pull
        self.pull_from_center('jackson', 'jackson-core-2.11.2.jar', '05836QJR')
        #jackson pull
        self.pull_from_center('jackson', 'jackson-databind-2.11.2.jar', '05836QJR')
        #double-conversion pull
        self.pull_from_center('double-conversion', 'v3.1.1.zip', '05833DJM')
        self.pull_from_center('psutil', 'psutil-5.7.0.tar.gz', '05834AVD')

    def pull_center(self):
        #fio pull
        self.pull_from_center('fio', 'fio-fio-3.8.tar.gz', '05832WND')
        #iperf pull
        self.pull_from_center('iperf', 'iperf-3.7.tar.gz', '05833PNC')
        #kafka python pull
        self.pull_from_center('kafka-python', 'kafka-python-2.0.0.tar.gz', '05835PPS')
        #zlib pull
        self.pull_from_center('zlib', 'zlib-1.2.11.tar.gz', '05832LKN')
        #cffi pull
        self.pull_from_center('cffi', 'cffi-1.12.3.tar.gz', '05833NKG')
        #zstd pull
        self.pull_from_center('zstd', 'zstd-1.4.4.tar.gz', '05833RAA')
        #unixodbc pull
        self.pull_from_center('unixodbc', 'unixODBC-2.3.9.tar.gz', '05836YTH')
        #snappy pull
        self.pull_from_center('snappy', '1.1.8.tar.gz', '05834ASH')
        #six pull
        self.pull_from_center('six', 'six-1.12.0.tar.gz', '05833CQA')
        #asn1crypto pull
        self.pull_from_center('asn1crypto', 'asn1crypto-1.2.0.tar.gz', '05833TCM')
        #cryptography pull
        self.pull_from_center('cryptography', 'cryptography-2.7.tar.gz', '05833JGS')
        #openssl pull
        self.pull_from_center('openssl', 'openssl-1.1.1g.tar.gz', '05834NCD')
        #pynacl pull
        self.pull_from_center('pynacl', 'pynacl-1.3.0.tar.gz', '05833ABT')
        #psutil pull
        self.pull_from_center('psutil', 'psutil-5.7.0.tar.gz', '05834AVD')
        #psqlodbc pull ODBC
        #self.pull_from_center('psqlodbc', 'psqlodbc-10.03.0000.tar.gz', '05832XYH')
        #pgxc pull
        #self.pull_from_center('pgxc', 'pgxc-v1.1.tar.gz', '05831RES')
        #postgresql-hll pull server
        #self.pull_from_center('postgresql-hll', 'postgresql-hll-2.10.2.zip', '05832TLV')
        #pljava pull server
        #self.pull_from_center('pljava', 'pljava_1.5.2_src.zip', '05833GUV')
        #postgresql-jdbc pull JDBC
        #self.pull_from_center('postgresql-jdbc', 'postgresql-jdbc-42.2.5.src.tar.gz', '05832WPE')
        #pcre pull
        self.pull_from_center('pcre', 'pcre-8.44.tar.gz', '05834AMQ')
        #paste pull
        self.pull_from_center('paste', 'paste-3.4.0.tar.gz', '05834JPG')
        #paramiko pull
        self.pull_from_center('paramiko', 'paramiko-2.6.0.tar.gz', '05833MWY')
        #orc pull
        self.pull_from_center('orc', 'orc-rel-release-1.6.0.tar.gz', '05833RAN')
        #numactl pull
        self.pull_from_center('numactl', 'numactl-2.0.13.tar.gz', '05833MQM')
        #nghttp2 pull
        self.pull_from_center('nghttp2', 'nghttp2-1.39.2.tar.gz', '05833PAX')
        #netifaces pull
        self.pull_from_center('netifaces', 'netifaces-release_0_10_9.tar.gz', '05833LEF')
        #ncurses pull
        # self.pull_from_center('ncurses', 'ncurses-6.2.tar.gz', '05834AVS')
        #lz4 pull
        self.pull_from_center('lz4', 'lz4-1.9.2.tar.gz', '05833QVT')
        #llvm pull
        self.pull_from_center('llvm', 'llvm-10.0.0.src.tar.xz', '05835YVM')
        #libxml2 pull 
        self.pull_from_center('libxml2', 'libxml2-2.9.9.tar.gz', '05833DFT')
        #libiconv pull
        self.pull_from_center('libiconv', 'libiconv-1.16.tar.gz', '05833PRU')
        #libevent pull
        self.pull_from_center('libevent', 'libevent-2.1.11-stable.tar.gz', '05833LTP')
        #libcgroup pull
        self.pull_from_center('libcgroup', 'libcgroup-0.41-21.el7.src.rpm', '05833VLC')
        #kerberos pull
        #self.pull_from_center('kerberos', 'krb5-1.17.1.tar.gz', '05833TFQ')
        #joda-time pull
        self.pull_from_center('joda-time', 'joda-time-2.10.6.jar', '05836EVA')
        #jemalloc pull
        self.pull_from_center('jemalloc', 'jemalloc-5.2.1.zip', '05833NWG')
        #jackson pull
        self.pull_from_center('jackson', 'jackson-annotations-2.11.2.jar', '05836QJR')
        #jackson pull
        self.pull_from_center('jackson', 'jackson-core-2.11.2.jar', '05836QJR')
        #jackson pull
        self.pull_from_center('jackson', 'jackson-databind-2.11.2.jar', '05836QJR')
        #ipaddress pull
        self.pull_from_center('ipaddress', 'ipaddress-1.0.22.tar.gz', '05832XTX')
        #idna pull
        self.pull_from_center('idna', 'idna-2.8.tar.gz', '05833CQF')
        #esdk_obs_api pull
        self.pull_from_center('esdk_obs_api', 'huaweicloud-sdk-c-obs-3.1.3.tar.gz', '05833HQG')
        #grpc pull
        self.pull_from_center('grpc', 'grpc-1.28.1.tar.gz', '05834MFX')
        #abseil-cpp pull
        self.pull_from_center('abseil-cpp', 'abseil-cpp-20200225.zip', '05835XEB')
        #protobuf pull
        self.pull_from_center('protobuf', 'protobuf-3.11.3.zip', '05834KWC')
        #glog pull
        self.pull_from_center('glog', 'glog-0.4.0.tar.gz', '05833NWR')
        #flatbuffers pull
        self.pull_from_center('flatbuffers', 'flatbuffers-1.11.0-src.zip', '05833LKH')
        #fastjson pull
        self.pull_from_center('fastjson', 'fastjson-1.2.70.jar', '05835TDF')
        #etcd pull server
        #self.pull_from_center('etcd', 'v3.3.18.zip', '05833SGS')
        #enum34 pull
        self.pull_from_center('enum34', 'enum34-1.1.9.tar.gz', '05834AFS')
        #libedit pull
        self.pull_from_center('libedit', 'libedit-20190324-3.1.tar.gz', '05833LPK')
        #double-conversion pull
        self.pull_from_center('double-conversion', 'v3.1.1.zip', '05833DJM')
        #libcurl pull
        self.pull_from_center('libcurl', 'curl-7.68.0.tar.gz', '05833WCD')
        #cJSON pull
        self.pull_from_center('cJSON', 'cJSON-1.7.13.tar.gz', '05834SXQ')
        #c-ares pull
        self.pull_from_center('c-ares', 'c-ares-1.15.0.tar.gz', '05833HTP')
        #brotli pull
        self.pull_from_center('brotli', 'brotli-1.0.7-src.zip', '05833HGN')
        #bottle pull
        #self.pull_from_center('bottle', 'bottle-0.12.17-src.zip', '05833NDF')
        #boost pull
        self.pull_from_center('boost', 'boost_1_72_0.tar.gz', '05834LEU')
        #bcrypt pull
        self.pull_from_center('bcrypt', 'bcrypt-3.1.7.tar.gz', '05833LMP')
        #libthrift pull
        self.pull_from_center('libthrift', 'thrift-0.13.0.tar.gz', '05833QEA')
        #parquet pull
        self.pull_from_center('parquet', 'apache-arrow-0.11.1.zip', '05833DJU')
        #httpclient pull
        self.pull_from_center('httpclient', 'httpclient-4.5.13.jar', '05837DRH')
        #httpcore pull
        self.pull_from_center('httpcore', 'httpcore-4.4.13.jar', '05834FRW')
        #commons-codec pull
        self.pull_from_center('commons-codec', 'commons-codec-1.11.jar', '05832USL')
        #commons-logging pull
        self.pull_from_center('commons-logging', 'commons-logging-1.2.jar', '05835NYL')
        #nanomsg pull 
        self.pull_from_center('nanomsg', 'nanomsg-1.1.5.tar.gz', '05833GBW')
        #slf4j pull
        self.pull_from_center('slf4j', 'slf4j-api-1.7.30.jar', '05834BMW')
        #rapidjson pull
        self.pull_from_center('rapidjson', 'rapidjson-4b3d7c2f42142f10b888e580c515f60ca98e2ee9.zip', '05833NMN')
        #pyasn1 pull
        self.pull_from_center('pyasn1', 'pyasn1-0.6.2.tar.gz', '05833MPT')
        #pycparser pull
        self.pull_from_center('pycparser', 'pycparser-2.19.tar.gz', '05833CLN')
        #pyOpenSSL pull
        self.pull_from_center('pyOpenSSL', 'pyOpenSSL-19.0.0.tar.gz', '05833EMP')
        #madlib_pull
        self.pull_from_center('madlib', 'apache-madlib-1.17.0-src.tar.gz', '05837HGE')

#--------------------------------------------------------#
# build mode parameter                                   #
#--------------------------------------------------------#

    def build(self):
        self.pull_center()

#--------------------------------------------------------#
# error log handler                                      #
#--------------------------------------------------------#

    def error_handler(self, ret):
        if ret:
            print("[ERROR] Invalid return code, exited")
            assert False


#--------------------------------------------------------#
# base interface for executing command                   #
#--------------------------------------------------------#

    def exe_cmd(self, cmd):
        if sys.version_info < (3, 5):
            ret = subprocess.call(cmd, shell = True)
        else:
            run_tsk = subprocess.run(cmd, shell = True, check = True)
            ret = run_tsk.returncode
        return ret
    
#--------------------------------------------------------#
# main function                                          #
#--------------------------------------------------------#

if __name__ == '__main__':
    Operator = OPOperator()
    #Operator.build()
    Operator.pull_from_center(sys.argv[1], sys.argv[2], sys.argv[3])

