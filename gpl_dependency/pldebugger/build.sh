#
# Copyright (c) 2020 Huawei Technologies Co.,Ltd.
#
# openGauss is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#
#          http://license.coscl.org.cn/MulanPSL2
#
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# ---------------------------------------------------------------------------------------
#
# Makefile
#     Makefile for the pldebugger
#
# IDENTIFICATION
#        contrib/pldebugger/Makefile
#
# ---------------------------------------------------------------------------------------

function usage()
{
    echo "Synopsis"
    echo "    $0 gaussdb-server-code-directory"
    echo " "
    echo "    The first argument (gaussdb-server-code-directory) is mandatory"
    exit 0
}

PLDEBUGGER_PACKAGE=pldebugger_3_0
PLDEBUGGER_PATCH=pldebugger_3_0_patch

SERVER_ROOTDIR=$1

if [ ! -d $SERVER_ROOTDIR ] || [ ! -d $SERVER_ROOTDIR/contrib ]; then
    echo "ERROR: there is no SERVER_ROOTDIR"
    usage
    exit 1
fi

test -d gplsrc || mkdir gplsrc
if [ -f "${PLDEBUGGER_PACKAGE}.tar.gz" ]; then
    rm -fr ./gplsrc/*
    tar -C gplsrc -xzf ${PLDEBUGGER_PACKAGE}.tar.gz

    rename ".c" ".cpp" gplsrc/pldebugger_3_0/*.c
fi

patch -p5 -d gplsrc/${PLDEBUGGER_PACKAGE} < ${PLDEBUGGER_PATCH}.patch

test -d $SERVER_ROOTDIR/contrib/pldebugger || mkdir -p $SERVER_ROOTDIR/contrib/pldebugger
rm -fr $SERVER_ROOTDIR/contrib/pldebugger/gplsrc
mv ./gplsrc $SERVER_ROOTDIR/contrib/pldebugger
cd $SERVER_ROOTDIR/contrib/pldebugger/gplsrc/${PLDEBUGGER_PACKAGE}

make || make && make install
if [ $? != 0 ]; then
    echo "ERROR: failed to install pldebugger"
    exit 1
fi
