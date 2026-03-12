#!/usr/bin/env python
# coding=utf-8
# description: Python script for open source software build.
# Copyright (c) 2020 Huawei Technologies Co.,Ltd.
# date: 2020-06-08

#-------------------------------------------------------------------------#
#usage:                                                                   #
#   python3/python build.py -m all -f openssl-1.1.1g.tar.gz -t "comm|llt" #
#   -m: build mode include all|build|shrink|dist|clean                    #
#   -t: build type include comm|llt|release|debug                         #
#   -f: tar file name                                                     #
#-------------------------------------------------------------------------#

import os
import subprocess
import sys
import argparse

#--------------------------------------------------------#
# open source software build operator                    #
#--------------------------------------------------------#

openssl_source_dir = "tassl"

class OPOperator():
    def __init__(self, mode, filename, compiletype):
        self.mode = mode
        self.filename = filename
        self.local_dir = os.getcwd()
        self.compiletype = compiletype.split('|')
        self.tmp_dir = os.getcwd()
        self.prefix_dir = '%s/openssl_make' % (self.tmp_dir)

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
        source_code_path = openssl_source_dir
        patch_list = self.patch_parser()
        # tar open source package
        tar_cmd = 'cd %s; mkdir -p %s; tar -zxvf %s -C %s --strip-components 1' % \
        (self.local_dir, source_code_path, self.filename, source_code_path)
        ret = self.exe_cmd(tar_cmd)
        self.error_handler(ret)
        # apply open source patch 
        if len(patch_list):
            for pre_patch in patch_list:
                patch_cmd = 'cd %s/%s; patch -p1 < ../%s' % (self.local_dir, source_code_path, pre_patch)
                ret = self.exe_cmd(patch_cmd)
                self.error_handler(ret)
        get_cpu_cmd = 'grep -w processor /proc/cpuinfo|wc -l'
        status, output = subprocess.getstatusoutput(get_cpu_cmd)
        self.error_handler(status)
        cpu_num = output.strip()
        # compile source code type
        for c_type in self.compiletype:
            if c_type == 'comm':
                prepare_cmd = 'rm -rf %s; mkdir -p %s; mkdir -p %s/install/comm' % (self.prefix_dir, self.prefix_dir, self.local_dir)
                ret = self.exe_cmd(prepare_cmd)
                self.error_handler(ret)
                config_cmd = 'cd %s/%s; ./config enable-ssl3-method -fPIC -shared -fstack-protector-strong -g -O2 -Wl,--build-id=none,-z,relro,-z,now,-z,noexecstack --prefix=%s --openssldir=%s' % (self.local_dir, source_code_path, self.prefix_dir, self.prefix_dir)
                ret = self.exe_cmd(config_cmd)
                self.error_handler(ret)
                make_cmd = 'cd %s/%s; make -j%s && make install' % (self.local_dir, source_code_path, cpu_num)
                ret = self.exe_cmd(make_cmd)
                self.error_handler(ret)
                cp_cmd = 'cp -r %s/* %s/install/comm; cd %s/%s; make clean' % (self.prefix_dir, self.local_dir, self.local_dir, source_code_path)
                ret = self.exe_cmd(cp_cmd)
                self.error_handler(ret)
            elif c_type == 'llt':
                prepare_cmd = 'rm -rf %s; mkdir -p %s; mkdir -p %s/install/llt' % (self.prefix_dir, self.prefix_dir, self.local_dir)
                ret = self.exe_cmd(prepare_cmd)
                self.error_handler(ret)
                config_cmd = 'cd %s/%s; ./config no-shared -fPIE -pie -fstack-protector-strong -g -O2 -Wl,--build-id=none,-z,relro,-z,now,-z,noexecstack --prefix=%s --openssldir=%s' % (self.local_dir, source_code_path, self.prefix_dir, self.prefix_dir)
                ret = self.exe_cmd(config_cmd)
                self.error_handler(ret)
                make_cmd = 'cd %s/%s; make -j%s && make install' % (self.local_dir, source_code_path, cpu_num)
                ret = self.exe_cmd(make_cmd)
                self.error_handler(ret)
                cp_cmd = 'cp -r %s/* %s/install/llt; cd %s/%s; make clean' % (self.prefix_dir, self.local_dir, self.local_dir, source_code_path)
                ret = self.exe_cmd(cp_cmd)
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
        for c_type in self.compiletype:
            if c_type == 'comm':
                cp_cmd1 = 'cp -r %s/install/comm/include %s/install_comm_dist' % (self.local_dir, self.local_dir)
                self.exe_cmd(cp_cmd1)
                cp_cmd2 = 'cp -r %s/install/comm/lib %s/install_comm_dist' % (self.local_dir, self.local_dir)
                self.exe_cmd(cp_cmd2)
            elif c_type == 'llt':
                cp_cmd1 = 'cp -r %s/install/llt/bin %s/install_comm_dist' % (self.local_dir, self.local_dir)
                self.exe_cmd(cp_cmd1)
            elif c_type == 'release':
                print ("[WARNING] Not supported build type")
            elif c_type == 'debug':
                print ("[WARNING] Not supported build type")
            else:
                print ("[WARNING] Not supported build type")
        mv_cmd1 = 'mv %s/install_comm_dist/lib/libssl.a %s/install_comm_dist/lib/libssl_static.a' % (self.local_dir, self.local_dir)
        self.exe_cmd(mv_cmd1)
        mv_cmd2 = 'mv %s/install_comm_dist/lib/libcrypto.a %s/install_comm_dist/lib/libcrypto_static.a' % (self.local_dir, self.local_dir)
        self.exe_cmd(mv_cmd2)
        rm_cmd = 'rm -rf %s/install_comm_dist/lib/engines-1.1 %s/install_comm_dist/lib/pkgconfig %s/install_comm_dist/bin/c_rehash' % (self.local_dir, self.local_dir, self.local_dir)
        self.exe_cmd(rm_cmd)
        chmod_cmd = 'chmod -x %s/install_comm_dist/lib/lib*.so.1.1' % (self.local_dir)
        self.exe_cmd(chmod_cmd)
        # finish shrink
        print ("[INFO] Shrink component finished")

#--------------------------------------------------------#
# move need component into matched platform binary path  #
#--------------------------------------------------------#

    def dist_component(self):
        install_path = '%s/../../output/kernel/dependency/tassl' % (self.local_dir)
        comm_path = "%s/comm" % install_path
        llt_path = "%s/llt" % install_path
        if not os.path.exists(install_path):
            os.makedirs(comm_path)
            os.makedirs(llt_path)
        # move source code type
        for c_type in self.compiletype:
            if c_type == 'comm':
                rm_cmd = 'rm -rf %s/comm/bin/* %s/comm/include/* %s/comm/lib/*' % (install_path, install_path, install_path)
                self.exe_cmd(rm_cmd)
                cp_cmd1 = 'cp -r %s/install_comm_dist/* %s/comm/' % (self.local_dir, install_path)
                self.exe_cmd(cp_cmd1)
            elif c_type == 'llt':
                rm_cmd = 'rm -rf %s/llt/bin/* %s/llt/include/* %s/llt/lib/*' % (install_path, install_path, install_path)
                self.exe_cmd(rm_cmd)
                cp_cmd1 = 'cp -r %s/install_comm_dist/* %s/llt/' % (self.local_dir, install_path)
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
        source_code_path = openssl_source_dir
        # clean source code
        clean_cmd = 'cd %s/%s; make clean' % (self.local_dir, source_code_path)
        ret = self.exe_cmd(clean_cmd)
        self.error_handler(ret)
        rm_cmd = 'cd %s; rm -rf %s; rm -rf install; rm -rf install_comm_dist; rm -rf %s' % (self.local_dir, source_code_path, self.prefix_dir)
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

