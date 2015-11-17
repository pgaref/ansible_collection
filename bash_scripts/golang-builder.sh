#!/bin/bash
#############################################
# This scripts resolves dependencies and 
# builds golang executables checked-out
# by Jenkins continous integration tool!             
# 
# Arguments: 
#
# Dependencies: path variables should be read from jenkins
# Path variables could be expanded                                      
#########################################

# Souce user profile
#. /home/admin/.bash_profile

## Export the needed variables instead
export LC_ALL=C
export PATH=$PATH:/usr/local/go/bin

set -e

function report_error(){
  echo "=> Error in golang-builder.sh while executing $BASH_COMMAND"
}
trap report_error ERR

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.
usage() { echo "Usage: $0 [-v (erbose)] [-j <Jenkins Path>] [-p <Project Path>] [-n <Job Name>] [-b <Build ID>]" 1>&2; exit 1; }

VERBOSE=0
JENKINS_HOME=$JENKINS_HOME
JOB_NAME=$JOB_NAME
BUILD_ID=$BUILD_ID

while getopts "h?j:n:b:v" opt; do
    case "$opt" in
    h|\?)
        usage
        exit 0
        ;;
    j)  JENKINS_HOME=${OPTARG}
        ;;
    n)  JOB_NAME=${OPTARG}
        ;;
    b)  BUILD_ID=${OPTARG}
        ;;
    v)  VERBOSE=1
        ;;
    *)  usage
        ;;
    esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

if [ $VERBOSE==1 ]; then
    echo -e "\n###########################################################"
    echo "Verbose=$VERBOSE, => JENKINS_HOME='$JENKINS_HOME'"
    echo "BUILD_ID='$BUILD_ID', JOB_NAME='$JOB_NAME' ARGS Leftovers: $@"
    echo -e "###########################################################\n"
fi


## Commands start here

# find the location of the script
if [[ -L "$0" ]]; then
    DIR="$(dirname "$(readlink -f "$0")")"
else
    DIR="${BASH_SOURCE%/*}"
fi
echo "Running builder from directory:$DIR"


#/var/lib/jenkins/jobs/panagiotis-trading-go-dev/builds/31/
export GOPATH="$JENKINS_HOME/jobs/$JOB_NAME/builds/$BUILD_ID/golang" 
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"
export DATA_API_PROJPATH="$GOPATH/src/bitbucket.org/***REMOVED***/data_api"
export TRADING_PROJPATH="$GOPATH/src/bitbucket.org/***REMOVED***/trading-system-framework"

# Extend this array according to the project needs!
build_paths=("$DATA_API_PROJPATH" "$TRADING_PROJPATH" "$TRADING_PROJPATH/runners/reports" 
                "$TRADING_PROJPATH/runners/allocations" "$TRADING_PROJPATH/runners/simulator"
                "$TRADING_PROJPATH/runners/keepAlive" "$TRADING_PROJPATH/runners/commission"
                "$TRADING_PROJPATH/runners/oms"
            )


if [ $VERBOSE==1 ]; then
    echo -e "\n###########################################################"
    echo "GOPATH: $GOPATH"
    echo "GOBIN: $GOBIN"
    echo "PATH: $PATH"
    echo -e "###########################################################\n"
fi

## Creating default GO directories
mkdir -p $GOPATH
mkdir -p $GOBIN
mkdir -p $DATA_API_PROJPATH
mkdir -p $TRADING_PROJPATH

if [ $VERBOSE==1 ]; then
    echo -e "\n###########################################################"
    echo "Current path: "$PWD
    echo -e "###########################################################\n"
fi


for path in ${build_paths[@]}; do
    cd $path
    if [ $VERBOSE==1 ]; then
        echo -e "\n###########################################################"
        echo "Currently Building: $path"
        echo " => PATH: $PWD"
        echo -e "###########################################################\n"
    fi
    ## Only Copy Godeps if directory exists!
    if [ -d "Godeps/_workspace/src" ]; then
        cp -rf Godeps/_workspace/src/* $GOPATH/src/
    fi
    go build -x
    go test ./...
done

###### IMPORTANT ##################
# Create csv File with Environmental Variables
# Needed for ansible tasks 
####################################

echo "Variable, Value" > /home/jenkins/golang-env.properties
echo "JENKINS_HOME,$JENKINS_HOME" >> /home/jenkins/golang-env.properties
echo "JOB_NAME,$JOB_NAME" >> /home/jenkins/golang-env.properties
echo "BUILD_ID,$BUILD_ID" >> /home/jenkins/golang-env.properties

