#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
# description: the script that download abseil-cpp
# date: 2020-11-25
# version: 1.0
# history:
# 2020-11-25 first commit

python $(pwd)/../../build/pull_open_source.py "abseil-cpp" "abseil-cpp-20200225.zip" "05835XEB"
rm -rf abseil-cpp-20200225
unzip -o abseil-cpp-20200225.zip
