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
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "${DIR}/base.sh"

function showUsageAndExit () {
    echoError "Insufficient or invalid options provided!"
    echo
    echoBold "Usage: ./push.sh -r [registry-url]"
    echo

    op_pversions=$(docker images | grep $product_name | awk '{print $1,"\t- ", $2}')
    if [ -n "$op_pversions" ]; then
        echo "Available product images:"
        echo "$op_pversions"
        echo
    fi

    echoBold "Options:"
    echo
    echo -en "  -r\t"
    echo "[REQUIRED] Docker registry url."
    echo -en "  -i\t"
    echo "[OPTIONAL] Docker image version."
    echo -en "  -l\t"
    echo "[OPTIONAL] '|' separated $(echo $product_name | awk '{print toupper($0)}') profiles to run. 'default' is selected if no value is specified."
    echo -en "  -o\t"
    echo "[OPTIONAL] Preferred organization name. If not specified, will be kept empty."
    echo

    echoBold "Ex: ./push.sh -v 6.1.1 -l 'integrator' -k 'wso2carbon' -r 'myregistry.local:5000'"
    echo
    exit 1
}

while getopts :n:v:i:o:r:l: FLAG; do
    case $FLAG in
        n)
            product_name=$OPTARG
            ;;
        v)
            product_version=$OPTARG
            ;;
        i)
            image_version=$OPTARG
            ;;
        o)
            organization_name=$OPTARG
            ;;
        r)
            registry_url=$OPTARG
            ;;
        l)
            product_profiles=$OPTARG
            ;;
        \?)
            showUsageAndExit
            ;;
    esac
done

# Validate mandatory args
if [ -z "$product_version" ]
  then
    showUsageAndExit
fi

if [ -z "$registry_url" ]
  then
    showUsageAndExit
fi

# Default values for optional args
if [ -z "$product_profiles" ]
  then
    product_profiles='default'
fi

# Appending characters to suit the image id
if [ ! -z "$image_version" ]
  then
    image_version="-${image_version}"
fi

if [ ! -z "$organization_name" ]
  then
    organization_name="${organization_name}/"
fi

IFS='|' read -r -a profiles_array <<< "${product_profiles}"
for profile in "${profiles_array[@]}"
do
    if [[ "${profile}" = "default" ]]; then
        image_name_and_version="${organization_name}${product_name}:${product_version}${image_version}"
    else
        image_name_and_version="${organization_name}${product_name}-${profile}:${product_version}${image_version}"
    fi

    {
        docker tag "${image_name_and_version}" "${registry_url}/${image_name_and_version}"
        docker push "${registry_url}/${image_name_and_version}"
    } || {
        echoError "Couldn't push image ${image_name_and_version} to registry ${registry_url}"
        exit 1
    }

    product_name_in_uppercase=`echo ${product_name} | tr '[:lower:]' '[:upper:]'`
    echoSuccess "${product_name_in_uppercase} ${profile} pushed image: [image] ${image_name_and_version} to [registry] ${registry_url}"
done
