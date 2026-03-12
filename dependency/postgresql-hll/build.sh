#!/bin/bash
# Copyright © Huawei Technologies Co., Ltd. 2010-2019. All rights reserved.
#  description: the script that make install hll libs
#  date: 2019-7-16
#  modified: 
#  version: 1.0
#  history:

work_path=$(dirname $0)
echo $work_path
source $work_path/build_global.sh
source $work_path/build_comm.sh
source $work_path/build_shrink.sh
source $work_path/build_dist.sh
#######################################################################
# main
#######################################################################
function main()
{
        python $(pwd)/../../build/pull_open_source.py "postgresql-hll" "postgresql-hll-2.14.zip" "05834MLL"
        case "${BUILD_OPTION}" in
            build)
                build_component
                ;;
            shrink)
                shrink_component
                ;;
            dist)
                dist_component
                ;;
            clean)
                clean_component	
                ;;
            only_so)
			    build_dist_so
			    ;;
            all)
                build_component
                shrink_component
                dist_component
                clean_component
                ;;
            *)
                log "Internal Error: option processing error: $2"   
                log "please input right paramenter values build, shrink, dist or clean "
        esac
}


########################################################################
if [ $# = 0 ] ; then
        log "missing option"
        print_help
        exit 1
fi

##########################################################################
#read command line paramenters
##########################################################################
while getopts "hm:" opt
do
    case "$opt" in
        m)
            if [[ "$OPTARG"X = ""X ]];then
                    die "no given version info"
            fi
            if [[ $# -lt 2 ]];then
                die "not enough params"
            fi
            BUILD_OPTION=$OPTARG
            main
            ;;
        h)
            print_help
            ;;
    esac
done

###########################################################################
