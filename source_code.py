# *************************************************************************
# Copyright: (c) Huawei Technologies Co., Ltd. 2022. All rights reserved
#
#  description: the script that download open source.
#  date: 2022-08-02
#  version: 3.1.0
#  history:
#      2022-08-02: add download opensources script.
# *************************************************************************

"""
pip3 install PyYAML
"""

import os
import subprocess
import yaml
import logging
import argparse
import shutil
import urllib.request
import hashlib

opensource_config = "OpenSource.yml"

DOWNLOAD_GITCLONE = "git clone"
DOWNLOAD_GITRESET= "git reset"
DOWNLOAD_WGET = "wget"

ACTION_TYPE_DOENLOAD = "download"
ACTION_TYPE_COPY = "copy"

CODE_TMP_DIR = "opensource"

log_format = "%(asctime)s - %(levelname)s - %(message)s"
logging.basicConfig(level=logging.INFO, format=log_format)

class Util:
    @staticmethod
    def rm_dir(path):
        if not os.path.exists(path):
            return
        cmd = "rm -rf %s" % path
        subprocess.getstatusoutput(cmd)

    @staticmethod
    def rm_file(file):
        if not os.path.exists(file):
            return
        os.remove(file)

    @staticmethod
    def create_dir(path):
        if os.path.exists(path):
            return
        cmd = "mkdir -p %s" % path
        subprocess.getstatusoutput(cmd)

class OpenSource():
    """
    download opensource from origin path likes github.
    """
    def __init__(self, type, item, from_obs):
        self.type = type
        self.itemlist = []
        if item:
            self.itemlist = item.split(",")
        self.is_down_fromobs = from_obs
        self.opensource_list = []
        self.current_dir = os.getcwd()
        self.opensource_dir = os.path.join(self.current_dir, CODE_TMP_DIR)

    def show_opensource(self):
        """
        display all opensources
        """
        self.__parse_cfg()
        print("Name".ljust(20," "), "Version".ljust(20," "), "Address".ljust(100, " "))
        index = 1
        for src in self.opensource_list:
            print("%4d" % index, src.get("name").ljust(20," "),
                  src.get("branch").ljust(20," "),
                  src.get("repo").ljust(100, " "))
            index += 1

    def main(self):
        """
        download opensources and compress them.
        """
        Util.create_dir(CODE_TMP_DIR)
        self.__parse_cfg()
        if self.type == ACTION_TYPE_DOENLOAD:
            self.__download_sources()
        elif self.type == ACTION_TYPE_COPY:
            self.__copydest()

    def __copydest(self):
        """
        copy opensource to dest dir under dependency in third_party repo.
        """
        for src in self.opensource_list:
            name = src.get("name")
            path = src.get("path")
            pkg_name = src.get("pkg_name")
            src_file = os.path.join(self.opensource_dir, pkg_name)
            target_file = os.path.join(self.current_dir, path, pkg_name)

            # shutil.copyfile(src_file, target_file)
            cmd = "cp {src} {target}".format(
                src=src_file, target=target_file
            )
            subprocess.getstatusoutput(cmd)

    def __parse_cfg(self):
        fd = open(opensource_config, 'r', encoding='utf-8')
        cfg = fd.read()
        params = yaml.load(cfg, Loader=yaml.SafeLoader)
        opensource_list = params['opengauss']

        # filter specify open source
        if len(self.itemlist) > 0:
            for src in opensource_list:
                if src.get("name") in self.itemlist:
                    self.opensource_list.append(src)
        else:
            self.opensource_list = opensource_list

    def __download_sources(self):
        index = 1
        for src in self.opensource_list:
            downtype = src.get("down_load_type")
            gitrepo = src.get("repo")
            branch = src.get("branch")
            down_url = src.get("url")
            name = src.get("name")
            pkg_name = src.get("pkg_name")
            sha256 = src.get("sha256")
            
            print("%4d. start download opensource[%s]" % (index, name))
            index += 1
            repo_path = os.path.join(self.opensource_dir, name)
            Util.rm_dir(repo_path)
            try:
                if downtype == DOWNLOAD_GITCLONE:
                    self.__download_gitclone(gitrepo, branch, name, repo_path)
                    self.__compress_source(name, pkg_name)
                elif downtype == DOWNLOAD_GITRESET:
                    self.__download_withreset(gitrepo, branch, name, repo_path)
                    self.__compress_source(name, pkg_name)
                elif downtype == DOWNLOAD_WGET:
                    self.__download_wget(down_url, pkg_name)
                else:
                    print("not found downloadtype")
                if sha256 and name != "openssl":
                    self.__checksum(pkg_name, sha256)
                    print(f"success check sha256 hash for {pkg_name}.")
            except Exception as e:
                print("download %s failed !!!" % repo_path)

    def __compress_source(self, name, pkg_name):
        cmd = "cd {repo_path} && tar -zcf {tarname} {sourcedir}".format(
            repo_path=self.opensource_dir, tarname=pkg_name, sourcedir=name
        )
        status, output = subprocess.getstatusoutput(cmd)
        if status != 0:
            print("compress pkg %s failed. cmd: %s, output: %s" % (name, cmd, output))

    def __download_gitclone(self, url, branch, name, repo_path):

        cmd = "cd {opensource} && git clone {repo} -b {branch} {rename} &&".format(
            opensource=self.opensource_dir, repo=url, branch=branch, rename=name
        )
        if name == "boost":
            cmd = "cd {opensource} && git clone --recursive {repo} -b {branch} " \
                  "{rename} &&".format(
                opensource=self.opensource_dir, repo=url, branch=branch, rename=name
            )
        cmd += "cd {repo_path} && git checkout -b {branch} && git pull origin {branch}".format(
            branch=branch, rename=name, repo_path=repo_path
        )
        status, output = subprocess.getstatusoutput(cmd)
        if status !=0 :
            print("git clone download code failed %s " % name)
            print(cmd)
            print(output)
        else:
            print("success download opensource[%s], type: git clone" % name)

    def __checksum(self, pkg_name, sha256):
        filefull = os.path.join(self.opensource_dir, pkg_name)
        qsha256sum = self.__get_sha256(filefull)
        if qsha256sum != sha256:
            raise Exception(f"Failed to check sum for file {pkg_name}. sha256 is not correct.")

    def __get_sha256(self, filename):
        h = hashlib.sha256()
        with open(filename, 'rb') as fh:
            while True:
                data = fh.read(4096)
                if len(data) == 0:
                    break
                else:
                    h.update(data)
        return h.hexdigest()
    
    def __download_wget(self, down_url, pkg_name):
        filefull = os.path.join(self.opensource_dir, pkg_name)
        currentfile = os.path.join(self.current_dir, down_url.split('/')[-1])
        Util.rm_file(filefull)
        if down_url.startswith("https://gitee.com"):
            process = subprocess.run(['wget', down_url],capture_output=True,text=True)
            if process.returncode != 0:
                print("failed to download opensource[%s], type: wget" % pkg_name)
            else:
                process = subprocess.run(['mv', currentfile, filefull],capture_output=True,text=True)
                print("success download opensource[%s], type: wget" % pkg_name)
        else:
            urllib.request.urlretrieve(down_url, filefull)
            print("success download opensource[%s], type: wget" % pkg_name)
    
    def __download_withreset(self, url, branch, name, repo_path):

        cmd = "cd {opensource} && git clone {repo} {rename} && cd {repo_path} && git reset --hard {commitid}".format(
            opensource=self.opensource_dir, repo=url, rename=name, repo_path=repo_path, commitid=branch
        )
        status, output = subprocess.getstatusoutput(cmd)
        if status != 0:
            print("git reset download code failed %s " % name)
            print(cmd)
            print(output)
        else:
            print("success download opensource[%s], type: git reset" % name)

def parse_params():
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', '--type', type=str, help="download or copy", required=False)
    parser.add_argument('-l', '--list', action='store_true', required=False)
    parser.add_argument('-i', '--item', type=str, help="specified open source", required=False)
    parser.add_argument('--from-obs', action='store_true', help="download from obs", required=False)
    return parser.parse_args()

"""
download opensources: python3 xxx.py -t download [--from-obs]
copy to dependency path: python3 xxx.py -t copy
"""
if __name__ == "__main__":
    args = parse_params()

    opens = OpenSource(args.type, args.item, args.from_obs)
    if args.list:
        opens.show_opensource()
    else:
        opens.main()