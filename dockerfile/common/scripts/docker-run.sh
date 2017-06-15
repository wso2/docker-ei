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
    echoBold "Usage: ./run.sh"
    echo

    op_pversions=$(docker images | grep $product_name | awk '{print $1,"\t- ", $2}')
    if [ -n "$op_pversions" ]; then
        echo "Available product images:"
        echo "$op_pversions"
        echo
    fi

    exposed_ports=$(grep -s 'EXPOSE' Dockerfile | cut -d' ' -f2-)
    if [ -n "$exposed_ports" ]; then
        exposed_ports="for the exposed ports ${exposed_ports}"
    fi

    echoBold "Options:"
    echo
    echo -en "  -i\t"
    echo "[OPTIONAL] Docker image version."
    echo -en "  -l\t"
    echo "[OPTIONAL] '|' separated $(echo $product_name | awk '{print toupper($0)}') profiles to run. 'default' is selected if no value is specified."
    echo -en "  -o\t"
    echo "[OPTIONAL] Organization name. 'wso2' is selected if no value is specified."
    echo -en "  -p\t"
    echo "[OPTIONAL] [MULTIPLE] Port mappings ${exposed_ports} of the container "
    echo -en "  -k\t"
    echo "[OPTIONAL] The keystore password if SecureVault was enabled in the product."
    echo -en "  -m\t"
    echo "[OPTIONAL] Full path of the host location to share with containers."
    echo

    echoBold "Ex: ./run.sh -v 6.1.1 -l 'integrator' -k 'wso2carbon'"
    echo
    exit 1
}

while getopts :n:v:i:o:p:l:k:m: FLAG; do
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
        l)
            product_profiles=$OPTARG
            ;;
        p)
            port_mappings="${port_mappings} -p $OPTARG"
            ;;
        k)
            key_store_password=$OPTARG
            ;;
        m)
            host_shared_dir_path=$OPTARG
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

# Default values for optional args
if [ -z "$product_profiles" ]
  then
    product_profiles='default'
fi

if [ -z "$port_mappings" ]
  then
    port_mappings='-P'
fi

if [ ! -z "$host_shared_dir_path" ]
  then
  volume_mapping=" -v $host_shared_dir_path:/mnt/wso2"
fi

if [ -z "$key_store_password" ]; then
    env_key_store_password=
else
    env_key_store_password="-e KEY_STORE_PASSWORD=${key_store_password}"
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
    name="${product_name}-${profile}"

    existing_container=$(docker ps -a | awk '{print $NF}' | grep "${name}")
    if [[ $existing_container = "$name" ]]; then
        echoError "A Docker container with the name ${name} already exists."
        askBold "Terminate existing ${name} container (y/n): "
        read -r terminate
        if [[ $terminate == "y" || $terminate == "Y" ]]; then
            docker rm -f "${name}" > /dev/null 2>&1 || { echoError "Couldn't terminate container ${name}."; exit 1; }
        else
            exit 1
        fi
    fi

    if [[ "${profile}" = "default" ]]; then
        container_id=$(docker run -d ${volume_mapping} ${port_mappings} ${env_key_store_password} --name "${name}" "${organization_name}${product_name}:${product_version}${image_version}")
    else
        container_id=$(docker run -d ${volume_mapping} ${port_mappings} ${env_key_store_password} --name "${name}" "${organization_name}${product_name}-${profile}:${product_version}${image_version}")
    fi

    member_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' "${container_id}")
    if [ -z "${member_ip}" ]; then
        echoError "Couldn't start container ${container_id} with name ${name}"
        exit 1
    fi

    product_name_in_uppercase=`echo ${product_name} | tr '[:lower:]' '[:upper:]'`
    echoSuccess "${product_name_in_uppercase} ${profile} container started: [name] ${name} [ip] ${member_ip} [container-id] ${container_id}"
    sleep 1
done

if [ "${#profiles_array[@]}" -eq 1 ]; then
    echo
    askBold "Connect to the spawned container? (y/n): "
    read -r exec_v
    if [[ "$exec_v" == "y" || "$exec_v" == "Y" ]]; then
        docker exec -it "${container_id}" /bin/bash
    else
        askBold "Tail container logs? (y/n): "
        read -r exec_v
        if [[ "$exec_v" == "y" || "$exec_v" == "Y" ]]; then
          docker logs -f "${container_id}"
        fi
    fi
else
    echo "To connect to a running container use following command..."
    echo "docker exec -it <containerId or name> bash"
fi
