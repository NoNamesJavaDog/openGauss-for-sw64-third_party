#!/usr/bin/env python
# coding=utf-8
# description: Python script for open source software build.
# Copyright (c) 2020 Huawei Technologies Co.,Ltd.
# date: 2020-06-08

#-------------------------------------------------------------------------#
#usage:                                                                   #
#   python build.py -m all -f krb5-1.17.1.tar.gz -t "comm|llt" #
#   -m: build mode include all|build|shrink|dist|clean                    #
#   -t: build type include comm|llt|release|debug                         #
#   -f: tar file name                                                     #
#-------------------------------------------------------------------------#

import os
import subprocess
import sys
import argparse
import subprocess

#--------------------------------------------------------#
# open source software build operator                    #
#--------------------------------------------------------#

source_code_path = "kerberos"
openssl_path = os.getcwd() + "/../../output/kernel/dependency/openssl/%s/%s"

class OPOperator():
    def __init__(self, mode, filename, compiletype):
        self.mode = mode
        self.filename = filename
        self.local_dir = os.getcwd()
        self.compiletype = compiletype.split('|')

#--------------------------------------------------------#
# parser build source code folder parameter              #
#--------------------------------------------------------#

    def folder_parser(self):
        ls_cmd = 'cd %s; ls ' % (self.local_dir)
        file_str = os.popen(ls_cmd).read()
        file_list = file_str.split('\n')
        for pre_str in file_list:
            if pre_str.find('.tar.gz') != -1:
                source_code = pre_str.split(".tar", 1)
                break
        return source_code[0]

#--------------------------------------------------------#
# parser build patch parameter                           #
#--------------------------------------------------------#

    def patch_parser(self):
        patch_list = []
        ls_cmd = 'cd %s; ls ' % (self.local_dir)
        file_str = os.popen(ls_cmd).read()
        file_list = file_str.split('\n')
        for pre_str in file_list:
            if pre_str.find('patch') != -1:
                patch_list.append(pre_str)
        return patch_list

#--------------------------------------------------------#
# parser build mode parameter                            #
#--------------------------------------------------------#

    def build_mode(self):
        # build mode
        if self.mode == 'build':
            self.build_component()
        elif self.mode == 'all':
            self.build_all()
        elif self.mode == 'shrink':
            self.shrink_component()
        elif self.mode == 'clean':
            self.clean_component()
        elif self.mode == 'dist':
            self.dist_component()
        else:
            print("[ERROR] Unrecognized build parameters, assert!")
            assert False

#--------------------------------------------------------#
# error log handler                                      #
#--------------------------------------------------------#

    def error_handler(self, ret):
        if ret:
            print("[ERROR] Invalid return code, exited")
            assert False

#--------------------------------------------------------#
# build all mode                                         #
#--------------------------------------------------------#

    def build_all(self):
        self.build_component()
        self.shrink_component()
        self.dist_component()
        self.clean_component()

#--------------------------------------------------------#
# build component mode                                   #
#--------------------------------------------------------#

    def build_component(self):
        patch_list = self.patch_parser()
        # tar open source package
        tar_cmd = 'cd %s; mkdir %s; tar -xvf %s -C %s --strip-components 1' % \
        (self.local_dir, source_code_path, self.filename, source_code_path)
        print ('cd %s; tar -xvf %s' % (self.local_dir, self.filename))
        ret = self.exe_cmd(tar_cmd)
        self.error_handler(ret)
        # get cpu core num
        get_cpu_cmd = 'grep -w processor /proc/cpuinfo|wc -l'
        status, output = subprocess.getstatusoutput(get_cpu_cmd)
        self.error_handler(status)
        cpu_num = output.strip()

        # apply open source patch 
        if len(patch_list):
            for pre_patch in patch_list:
                patch_cmd = 'cd %s/%s; patch -p1 < ../%s' % (self.local_dir, source_code_path, pre_patch)
                ret = self.exe_cmd(patch_cmd)
                self.error_handler(ret)
        status, output = subprocess.getstatusoutput('uname -m')
        self.error_handler(status)
        cpu_arch = output
        if cpu_arch in ('loongarch64') :
            ret = self.exe_cmd('cd %s/%s; cp -rf %s/../../build-aux/* ./src/config/' % (self.local_dir, source_code_path, self.local_dir))
            self.error_handler(ret)
        if cpu_arch in ('sw_64',) :
            ret = self.exe_cmd('cp /usr/share/automake-1.16/config.guess %s/%s/src/config/config.guess && cp /usr/share/automake-1.16/config.sub %s/%s/src/config/config.sub' % (self.local_dir, source_code_path, self.local_dir, source_code_path))
            self.error_handler(ret)
        gen_cmd="cd %s/%s/src; rm configure; autoconf; autoheader; sed -i 's/lcom_err/lcom_err_gauss/g' configure" % (self.local_dir, source_code_path)
        ret = self.exe_cmd(gen_cmd)
        self.error_handler(ret)
        # compile source code type
        for c_type in self.compiletype:
            if c_type == 'comm':
                prepare_cmd = 'mkdir -p %s/install/comm' % (self.local_dir)
                ret = self.exe_cmd(prepare_cmd)
                self.error_handler(ret)
                openssl_comm_lib = (openssl_path % ("comm", "lib"))
                openssl_comm_include = (openssl_path % ("comm", "include"))
                config_cmd = "cd %s/%s/src; ./configure --prefix=%s/install/comm  LDFLAGS='-Wl,-z,relro,-z,now -L%s' CFLAGS='-fstack-protector-strong -fPIC -I%s' --disable-rpath --disable-pkinit --with-system-verto=no" % (self.local_dir, source_code_path, self.local_dir, openssl_comm_lib, openssl_comm_include)
                print(config_cmd)
                ret = self.exe_cmd(config_cmd)
                self.error_handler(ret)
                make_cmd = 'cd %s/%s/src; make -j%s && make install' % (self.local_dir, source_code_path, cpu_num)
                ret = self.exe_cmd(make_cmd)
                self.error_handler(ret)
            elif c_type == 'llt':
                prepare_cmd = 'mkdir -p %s/install/llt' % (self.local_dir)
                ret = self.exe_cmd(prepare_cmd)
                self.error_handler(ret)
                openssl_llt_lib = (openssl_path % ("llt", "lib"))
                openssl_llt_include = (openssl_path % ("llt", "include"))
                config_cmd = "cd %s/%s/src; ./configure --prefix=%s/install/llt LDFLAGS='-Wl,-z,relro,-z,now -L%s' CFLAGS='-fstack-protector-strong -fPIC -I%s' --disable-rpath --disable-pkinit --with-system-verto=no" % (self.local_dir, source_code_path, self.local_dir, openssl_llt_lib, openssl_llt_include)
                print(config_cmd)
                ret = self.exe_cmd(config_cmd)
                self.error_handler(ret)
                make_cmd = 'cd %s/%s/src; make -j%s && make install' % (self.local_dir, source_code_path, cpu_num)
                ret = self.exe_cmd(make_cmd)
                self.error_handler(ret)

            elif c_type == 'release':
                print ("[WARNING] Not supported build type")
            elif c_type == 'debug':
                print ("[WARNING] Not supported build type")
            else:
                print ("[WARNING] Not supported build type")
        # finish compile
        print ("[INFO] Build component finished")

#--------------------------------------------------------#
# copy open source component for using mode              #
#--------------------------------------------------------#

    def shrink_component(self):
        # shrink source code type
        install_dist_cmd = 'mkdir -p %s/install_comm_dist' % (self.local_dir)
        ret = self.exe_cmd(install_dist_cmd)
        self.error_handler(ret)
        install_dist_cmd_llt = 'mkdir -p %s/install_llt_dist' % (self.local_dir)
        ret = self.exe_cmd(install_dist_cmd_llt)
        self.error_handler(ret)
        for c_type in self.compiletype:
            if c_type == 'comm':
                cp_cmd1 = 'cp -r %s/install/comm/* %s/install_comm_dist/' % (self.local_dir, self.local_dir)
                self.exe_cmd(cp_cmd1)
                cp_cmd2 = 'rm -r %s/install_comm_dist/lib/pkgconfig' % (self.local_dir)
                self.exe_cmd(cp_cmd2)
                cp_cmd3 = 'rm -r %s/install_comm_dist/share' % (self.local_dir)
                self.exe_cmd(cp_cmd3)
                cp_cmd4 = 'rm -r %s/install_comm_dist/var' % (self.local_dir)
                self.exe_cmd(cp_cmd4)
            elif c_type == 'llt':
                cp_cmd1 = 'cp -r %s/install/llt/* %s/install_llt_dist/' % (self.local_dir, self.local_dir)
                self.exe_cmd(cp_cmd1)
                cp_cmd2 = 'rm -r %s/install_llt_dist/lib/pkgconfig' % (self.local_dir)
                self.exe_cmd(cp_cmd2)
                cp_cmd3 = 'rm -r %s/install_llt_dist/share' % (self.local_dir)
                self.exe_cmd(cp_cmd3)
                cp_cmd4 = 'rm -r %s/install_llt_dist/var' % (self.local_dir)
                self.exe_cmd(cp_cmd4)
            elif c_type == 'release':
                print ("[WARNING] Not supported build type")
            elif c_type == 'debug':
                print ("[WARNING] Not supported build type")
            else:
                print ("[WARNING] Not supported build type")
        # finish shrink
        print ("[INFO] Shrink component finished")

#--------------------------------------------------------#
# move need component into matched platform binary path  #
#--------------------------------------------------------#

    def dist_component(self):
        install_path = '%s/../../output/kernel/dependency/kerberos' % (self.local_dir)
        comm_path = "%s/comm" % install_path
        llt_path = "%s/llt" % install_path
        if not os.path.exists(install_path):
            os.makedirs(comm_path)
            os.makedirs(llt_path)
        install_dist_path = '%s/install_comm_dist' % (self.local_dir)
        install_dist_path_llt = '%s/install_llt_dist' % (self.local_dir)
        # move source code type
        for c_type in self.compiletype:
            if c_type == 'comm':
                rm_cmd = 'rm -rf %s/comm/*' % (install_path)
                self.exe_cmd(rm_cmd)
                cp_cmd1 = 'cp -dr %s/* %s/comm/' % (install_dist_path, install_path)
                self.exe_cmd(cp_cmd1)
            elif c_type == 'llt':
                rm_cmd = 'rm -rf %s/llt/*' % (install_path)
                self.exe_cmd(rm_cmd)
                cp_cmd1 = 'cp -dr %s/* %s/llt/' % (install_dist_path_llt, install_path)
                self.exe_cmd(cp_cmd1)
            elif c_type == 'release':
                print ("[WARNING] Not supported build type")
            elif c_type == 'debug':
                print ("[WARNING] Not supported build type")
            else:
                print ("[WARNING] Not supported build type")
        # finish dist
        print ("[INFO] Dist component finished")

#--------------------------------------------------------#
# clean component mode                                   #
#--------------------------------------------------------#

    def clean_component(self):
        # clean source code
        clean_cmd = 'cd %s/%s/src; make clean' % (self.local_dir, source_code_path)
        print('cd %s/%s/src; make clean' % (self.local_dir, source_code_path))
	
        ret = self.exe_cmd(clean_cmd)
        self.error_handler(ret)
        rm_cmd = 'cd %s; rm -rf %s; rm -rf install; rm -rf install_comm_dist; rm -rf install_llt_dist' % (self.local_dir, source_code_path)
        ret = self.exe_cmd(rm_cmd)
        self.error_handler(ret)
        # finish clean
        print ("[INFO] Clean component finished")

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
# build script operator parameter parser                 #
#--------------------------------------------------------#

def parse_args():
    parser = argparse.ArgumentParser(description='GaussDB Kernel open source software build script')
    
    parser.add_argument('-m', '--mode', type=str, required=True,
                        help='build mode set, all|build|shrink|dist|clean')
    parser.add_argument('-f', '--filename', type=str, required=True,
                        help='file name set')
    parser.add_argument('-t', '--compiletype', type=str, required=True,
                        help='compile type set "comm|llt|release|debug"')
    return parser.parse_args()

#--------------------------------------------------------#
# main function                                          #
#--------------------------------------------------------#

if __name__ == '__main__':
    args = parse_args()
    Operator = OPOperator(mode = args.mode, filename = args.filename, compiletype = args.compiletype)
    Operator.build_mode()

