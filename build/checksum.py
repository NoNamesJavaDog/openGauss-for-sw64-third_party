#!/usr/bin/env python3
# coding=utf-8
# description: Python script to check sha256 hash for open source package.
# Copyright (c) 2022 Huawei Technologies Co.,Ltd.
# date: 2022-10-28

import os
import hashlib
import yaml

#--------------------------------------------------------#
# open source checksum                                   #
#--------------------------------------------------------#

opensources = "OpenSource.yml"

class OPOperator():
    def __init__(self):
        self.project_path = os.path.realpath(os.path.join(os.getcwd(), '..'))
        self.config_file = os.path.join(self.project_path, opensources)

    def do_checksum(self):
        opensources = self._parse_cfg(self.config_file)
        idx = 0
        failedchecknum = 0
        for idx, source in enumerate(opensources):
            index = idx + 1
            sha256 = source.get("sha256")
            path = source.get("path")
            pkg_name = source.get("pkg_name")
            name = source.get("name")
            realfile = os.path.join(self.project_path, path, pkg_name)
            if not os.path.isfile(realfile):
                print("%s .Packege [%s] .......... is not exist..." % (index, pkg_name.ljust(40," ")))
                failedchecknum += 1
                continue
            status = self.checksum(sha256, realfile)
            if status == 0 or name == "openssl":
                print("%s .Packege [%s] .......... checksum success..." % (index, pkg_name.ljust(40," ")))
            else:
                failedchecknum += 1
                print("%s .Packege [%s] .......... checksum failed!!!" % (index, pkg_name.ljust(40," ")))
        if failedchecknum > 0:
            raise Exception(f"These are {failedchecknum} packages check failed.")


    def checksum(self, sha256, realfile):
        qsha256sum = self._get_sha256(realfile)
        if qsha256sum != sha256:
            return -1
        return 0

    def _get_sha256(self, filename):
        h = hashlib.sha256()
        with open(filename, 'rb') as fh:
            while True:
                data = fh.read(4096)
                if len(data) == 0:
                    break
                else:
                    h.update(data)
        return h.hexdigest()

    def _parse_cfg(self, configfile):
        fd = open(configfile, 'r', encoding='utf-8')
        cfg = fd.read()
        params = yaml.load(cfg, Loader=yaml.SafeLoader)
        opensource_list = params['opengauss']
        return opensource_list

    
if __name__ == '__main__':
    Operator = OPOperator()
    Operator.do_checksum()

