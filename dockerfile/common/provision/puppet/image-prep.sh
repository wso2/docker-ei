#!/bin/bash
# ------------------------------------------------------------------------
#
# Copyright 2016 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

# ------------------------------------------------------------------------

set -e

provision_path=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "${provision_path}/../../scripts/base.sh"

# Check if a Puppet folder is set
if [ -z "$PUPPET_HOME" ]; then
    echoError "Puppet home folder could not be found! Set PUPPET_HOME environment variable pointing to local puppet folder."
    exit 1
fi

# $1 product environment = dev
function validateProductEnvironment() {
    env_dir="${PUPPET_HOME}/hieradata/${1}"
    if [ ! -d "$env_dir" ]; then
        echoError "Provided product environment ${1} doesn't exist in PUPPET_HOME: ${PUPPET_HOME}. Available environments are,"
        listFiles "${PUPPET_HOME}/hieradata/"
        echo
        exit 1
    fi
}

# $1 module name = wso2esb
# $2 product version = 4.9.0
# $3 product environment = dev
# $4 pattern number = 1
function validateDeploymentPattern() {
    pattern_dir="${PUPPET_HOME}/hieradata/${3}/wso2/${1}/pattern-${4}"
    if [ ! -d "$pattern_dir" ]; then
        echoError "Provided deployment pattern ${1}:${2}-pattern-${4} doesn't exist in PUPPET_HOME: ${PUPPET_HOME}. Available versions are,"
        listFiles "${PUPPET_HOME}/hieradata/${3}/wso2/${1}/"
        echo
        exit 1
    fi
}

# $1 module name = wso2esb
# $2 product version = 4.9.0
# $3 product profile list = 'integrator|analytics|business-process|broker'
# $4 product environment = dev
# $5 pattern number = 1
function validateProfile() {
    invalidFound=false
    IFS='|' read -r -a array <<< "${3}"
    for profile in "${array[@]}"
    do
        profile_yaml="${PUPPET_HOME}/hieradata/${4}/wso2/${1}/pattern-${5}/${profile}.yaml"
        echo "profile yaml:${profile_yaml}"
        if [ ! -e "${profile_yaml}" ] || [ ! -s "${profile_yaml}" ]
        then
            invalidFound=true
        fi
    done

    if [ "${invalidFound}" == true ]
    then
        echoError "One or more provided product profiles ${1}:${2}-[${3}] do not exist in PUPPET_HOME: ${PUPPET_HOME}. Available profiles are,"
        listFiles "${PUPPET_HOME}/hieradata/${4}/wso2/${1}/pattern-${5}"
        echo
        exit 1
    fi
}

# $1 module name = wso2esb
# $2 product name = wso2esb
# $3 product version = 4.9.0
function validateNeededPacks() {
    local base_files_dir="${PUPPET_HOME}/modules/wso2base/files"
    if [ -z $(find ${base_files_dir} -name "jdk*.tar.gz") ]; then
        echoError "A JDK was not found. Copy the JDK in to ${base_files_dir}."
        exit 1
    fi

    local product_files_dir="${PUPPET_HOME}/modules/${1}/files"
    if [ ! -f "${product_files_dir}/${2}-${3}.zip" ]; then
        if [ ! -z $( find ${product_files_dir} -name ${2}-*.zip ) ]; then
            echoError "$(echo ${1} | awk '{print toupper($0)}') pack(s) other than version ${3} has been found at ${product_files_dir} directory. Expected: ${2}-${3}.zip"
            exit 1
        else
            echoError "$(echo ${1} | awk '{print toupper($0)}') ${3} pack was not found at ${product_files_dir} directory. Expected: ${2}-${3}.zip"
            exit 1
        fi
    fi
}

# check if provided product environment exists in PUPPET_HOME
validateProductEnvironment "${product_env}"

#check if provided deployment pattern exists in PUPPET_HOME
validateDeploymentPattern "${module_name}" "${product_version}" "${product_env}" "${pattern_no}"

# check if provided profile exists in PUPPET_HOME
validateProfile "${module_name}" "${product_version}" "${product_profiles}" "${product_env}" "${pattern_no}"

# check if packs are copied to PUPPET_HOME
validateNeededPacks "${module_name}" "${product_name}" "${product_version}"

export file_location=${PUPPET_HOME}
