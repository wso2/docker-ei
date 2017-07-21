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
function cleanup() {
  echoBold "Cleaning..."
  rm -rf "$dockerfile_path/scripts"
  if [[ ! -z $httpserver_pid ]]; then
    kill -9 $httpserver_pid > /dev/null 2>&1
  fi
}
trap cleanup EXIT
set -e

SECONDS=0
self_path=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "${self_path}/base.sh"

# Show usage and exit
function showUsageAndExit() {
  echoError "Insufficient or invalid options provided!"
  echo
  echoBold "Usage: ./build.sh"
  echo

  available_provisioning=$(listFiles ${self_path}/../provision)
  available_provisioning=$(echo $available_provisioning | tr ' ' ', ')

  echoBold "Options:"
  echo
  echo -en "  -l\t"
  echo "[OPTIONAL] '|' separated $(echo $product_name | awk '{print toupper($0)}') profiles to build. All the profiles are selected if no value is specified."
  echo -en "  -i\t"
  echo "[OPTIONAL] Docker image version."
  echo -en "  -e\t"
  echo "[OPTIONAL] Product environment. If not specified this is defaulted to \"dev\"."
  echo -en "  -o\t"
  echo "[OPTIONAL] Preferred organization name. If not specified, will be kept empty."
  echo -en "  -q\t"
  echo "[OPTIONAL] Quiet flag. If used, the docker build run output will be suppressed."
  echo -en "  -r\t"
  echo "[OPTIONAL] Provisioning method. If not specified this is defaulted to \"default\". Available provisioning methods are ${available_provisioning//,/, }."
  echo -en "  -t\t"
  echo "[OPTIONAL] Image name. If this is specified, it will be used as the image name instead of \"wso2{product}\" format."
  echo -en "  -y\t"
  echo "[OPTIONAL] Automatic yes to prompts; assume \"y\" (yes) as answer to all prompts and run non-interactively."
  echo -en "  -s\t"
  echo "[OPTIONAL] Platform to be used to run the Dockerfile (ex.: kubernetes). If not specified will assume the value as 'default'."
  echo -en "  -p\t"
  echo "[OPTIONAL] Deployment pattern number. If the pattern is not specified pattern \"1\" will be used."
  echo -en "  -m\t"
  echo "[OPTIONAL] Puppet module name. If the module name is not specified \"product name\" will be used."
  echo

  echoBold "Ex: ./build.sh -p 2 -r puppet -l integrator|analytics|business-process|broker"
  echoBold "Ex: ./build.sh -l integrator|analytics|business-process|broker -o myorganization -i 1.0.0"
  echoBold "Ex: ./build.sh -t wso2ei-customized"
  echo
  exit 1
}

function timeout() {
    perl -e 'alarm shift; exec @ARGV' "$@";
}

# ${1} Current docker version
# ${2} Minimum required docker version
function validateDockerVersion(){
  IFS='.' read -r -a version_1 <<< "$1"
  IFS='.' read -r -a version_2 <<< "$2"
  if (( "${version_1[0]}" > "${version_2[0]}" )) ; then
     return
  elif (( "${version_1[0]}" == "${version_2[0]}" )) ; then
    if(( "${version_1[1]}" >= "${version_2[1]}" )) ; then
        return
    fi
  fi
  echoError "Docker version should be equal to or greater than ${min_required_docker_version} to build WSO2 Docker images. Found ${docker_version}"
  exit 1
}

function findHostIP() {
  local _ip _line
  while IFS=$': \t' read -a _line; do
    [ -z "${_line%inet}" ] \
    && _ip=${_line[${#_line[1]}>4?1:2]} \
    && [ "${_ip#127.0.0.1}" ] \
    && echo $_ip \
    && return 0
  done< <(LANG=C /sbin/ifconfig)
}

# ${1} product environment
# ${2} product name
# ${3} pattern number
function getAllProfiles() {
    local pattern_dir="${PUPPET_HOME}/hieradata/${1}/wso2/${2}/pattern-${3}/";
    local profile_files=$( find "${pattern_dir}" -maxdepth 1 -mindepth 1 -name "*.yaml" \( ! -iname ".*" ! -iname "*.md" ! -iname "common.yaml" \)| rev | cut -d '/' -f1 | rev | awk NF )
    read -a arr <<<${profile_files}

    local profiles=""
    for profile in "${arr[@]}"
    do
        local profile_name=$( echo "${profile}" | rev | cut -d "." -f2 | rev )
        local profiles="${profiles}|${profile_name}"
    done

    echo ${profiles:1}
}

verbose=true
provision_method="default"
overwrite_v='n'
platform='default'

while getopts :r:n:v:d:l:i:o:e:t:s:m:q:y:p: FLAG; do
  case $FLAG in
    r)
      provision_method=$OPTARG
      ;;
    q)
      verbose=false
      ;;
    n)
      product_name=$OPTARG
      ;;
    v)
      product_version=$OPTARG
      ;;
    d)
      dockerfile_path=$OPTARG
      ;;
    i)
      image_version=$OPTARG
      ;;
    l)
      product_profiles=$OPTARG
      ;;
    o)
      organization_name=$OPTARG
      ;;
    e)
      product_env=$OPTARG
      ;;
    t)
      tag_name=$OPTARG
      ;;
    y)
      overwrite_v='y'
      ;;
    s)
      platform=$OPTARG
      ;;
    m)
      module_name=$OPTARG
      ;;
    p)
      pattern_no=$OPTARG
      ;;
    \?)
      showUsageAndExit
      ;;
  esac
done

if [[ -z $product_version ]] || [[ -z $product_name ]] || [[ -z $dockerfile_path ]]; then
  showUsageAndExit
fi

if [[ -z $product_env ]]; then
  product_env="dev"
fi

# org name adjustment
if [[ ! -z $organization_name ]]; then
  organization_name="${organization_name}/"
fi

# Default values for optional args
if [[ -z $pattern_no ]]; then
  pattern_no="1"
fi

if [[ -z $module_name ]]; then
  module_name="${product_name}"
fi

if [[ -z $product_profiles ]]; then
    if [[ $provision_method != "default" ]]; then
        product_profiles=$( getAllProfiles ${product_env} ${module_name} ${pattern_no} )
    else
        product_profiles="default"
    fi
fi

provisioning_dir="${self_path}/../provision"
if [[ ! -d "${provisioning_dir}/${provision_method}" ]]; then
  echoError "Unable to find the provisioning method '${provision_method}'"
  echo "Available provisioning methods:"
  echo "$(listFiles ${self_path}/../provision)"
  exit 1
fi

echo "Provisioning Method: ${provision_method}"

image_config_file="${provisioning_dir}/${provision_method}/image-config.sh"
image_prep_file="${provisioning_dir}/${provision_method}/image-prep.sh"
if [[ ! -f  $image_config_file ]]; then
  echoError "Unable to find image-config.sh script for provisioning method ${provision_method}"
  exit 1
fi

if [[ ! -f $image_prep_file ]]; then
  echoError "Unable to find image-prep.sh script for provisioning method ${provision_method}"
  exit 1
fi

pushd "${self_path}/../provision/${provision_method}" > /dev/null 2>&1
source image-prep.sh $*
popd > /dev/null 2>&1

# validate docker version against minimum required docker version
# docker_version=$(docker version --format '{{.Server.Version}}')
docker_version=$(docker version)
docker_version=$(echo "$docker_version" | grep 'Version:' | awk '{print $2}')
min_required_docker_version=1.10.0
validateDockerVersion "${docker_version}" "${min_required_docker_version}"

# Copy common files to Dockerfile context
echoBold "Creating Dockerfile context..."
mkdir -p "${dockerfile_path}/scripts"
cp "${self_path}/entrypoint.sh" "${dockerfile_path}/scripts/init.sh"
cp "${self_path}/../provision/${provision_method}/image-config.sh" "${dockerfile_path}/scripts/image-config.sh"

# get host machine ip
host_ip=$(findHostIP)
if [[ -z $host_ip ]]; then
  echoError "Could not find host ip address. Exiting..."
  exit 1
fi

# Select a port between 8000 - 8100 for the http server
http_server_port=8000
while timeout 1 bash -c "cat < /dev/null > /dev/tcp/${host_ip}/${http_server_port}"; do
  echoDim "Port ${http_server_port} seems to be already in use, trying port $((http_server_port + 1))..."
  http_server_port=$((http_server_port + 1))
  if [[ $http_server_port = 8100 ]]; then
    echoError "Could not find a free port between 8000 - 8100. Exiting..."
    exit 1
  fi
done
echoDim "Port ${http_server_port} was selected for the http server"

# start the server in background
http_server_address="http://${host_ip}:${http_server_port}"
pushd ${file_location} > /dev/null 2>&1
echoBold "Starting HTTP server [Doc Root] ${file_location}, [URL] ${http_server_address}"
python2.7 -m SimpleHTTPServer $http_server_port & > /dev/null 2>&1
httpserver_pid=$!
RETRY_COUNT=${RETRY_COUNT:-10}
count=0
while ([[ $(curl --silent --output /dev/null --write-out "%{http_code}" $http_server_address) -ne 200 ]] \
       && [[ "$count" -lt "$RETRY_COUNT" ]]); do
  count=$((count + 1))
  sleep 0.5s
done
if [[ "$count" -lt "$RETRY_COUNT" ]]; then
  echoBold "HTTP server started successfully on ${http_server_address}"
else
  echoError "HTTP server failed to start within timeout count of ${RETRY_COUNT}"
fi
popd > /dev/null 2>&1

# Build image for each profile provided
IFS='|' read -r -a profiles_array <<< "${product_profiles}"
for profile in "${profiles_array[@]}"; do
  #add image version to tag if specified
  if [[ -z $image_version ]]; then
    image_version_section=$product_version
  else
    image_version_section="${product_version}-${image_version}"
  fi

  if [[ -z $tag_name ]]; then
    tag_name=$product_name
  fi

  # set image name according to the profile list
  if [[ "${profile}" = "default" ]]; then
    image_name_section="${organization_name}${tag_name}"
  else
    image_name_section="${organization_name}${tag_name}-${profile}"
  fi

  if [[ "${platform}" != "default" ]]; then
    image_name_section="${image_name_section}-${platform}"
  fi

  image_id="${image_name_section}:${image_version_section}"

  image_exists=$(docker images $image_id | wc -l)
  if [[ ${image_exists} -eq 2 ]] && [[ $overwrite_v != "y" ]]; then
    if [ $verbose == false ]; then
      overwrite_v='y';
    else
      askBold "Docker image \"${image_id}\" already exists? Overwrite? (y/n): "
      read -r overwrite_v
    fi
  fi

  # Expose transport ports based on the profile and pattern number
  if [ "$profile" = "analytics" ] && [ "$pattern_no" = "1" ]; then
    sed -i "s#EXPOSE .*#EXPOSE 9612 9712 7712 7612 9764 9444#" "${dockerfile_path}/Dockerfile"
  elif [ "$profile" = "analytics" ] && [ "$pattern_no" = "2" ]; then
    sed -i "s#EXPOSE .*#EXPOSE 9611 9711 7711 7611 9763 9443#" "${dockerfile_path}/Dockerfile"
  elif [ "$profile" = "business-process" ] && [ "$pattern_no" = "1" ]; then
    sed -i "s#EXPOSE .*#EXPOSE 9765 9445#" "${dockerfile_path}/Dockerfile"
  elif [ "$profile" = "business-process" ] && [ "$pattern_no" = "2" ]; then
    sed -i "s#EXPOSE .*#EXPOSE 9763 9443#" "${dockerfile_path}/Dockerfile"
  elif [ "$profile" = "broker" ] && [ "$pattern_no" = "1" ]; then
    sed -i "s#EXPOSE .*#EXPOSE 1886 8886 5675 8675 7614 9766 9446#" "${dockerfile_path}/Dockerfile"
  elif [ "$profile" = "broker" ] && [ "$pattern_no" = "2" ]; then
    sed -i "s#EXPOSE .*#EXPOSE 1883 8883 5672 8672 7611 9763 9443#" "${dockerfile_path}/Dockerfile"
  else
    sed -i "s#EXPOSE .*#EXPOSE 8280 8243 9763 9443#" "${dockerfile_path}/Dockerfile"
  fi

  if [[ ${image_exists} -eq "1" ]] || [[ $overwrite_v == "y" ]]; then
    # if there is a custom init.sh script supplied specific for the profile of this product, pack
    # it to ${dockerfile_path}/scripts/
    product_init_script_name="${product_name}-${profile}-init.sh"
    if [[ -f "${dockerfile_path}/${product_init_script_name}" ]]; then
      pushd "${dockerfile_path}" > /dev/null
      cp "${product_init_script_name}" scripts/
      popd > /dev/null
    fi

    echoBold "Building docker image ${image_id}..."

    build_cmd="docker build --no-cache=true \
                --build-arg WSO2_SERVER=\"${product_name}\" \
                --build-arg WSO2_SERVER_VERSION=\"${product_version}\" \
                --build-arg WSO2_SERVER_PROFILE=\"${profile}\" \
                --build-arg WSO2_ENVIRONMENT=\"${product_env}\" \
                --build-arg WSO2_DEPLOYMENT_PATTERN=\"${pattern_no}\" \
                --build-arg HTTP_PACK_SERVER=\"${http_server_address}\" \
                --build-arg PLATFORM=\"${platform}\" \
                -t \"${image_id}\" \"${dockerfile_path}\""
    {
      if [[ $verbose == true ]]; then
        ! eval $build_cmd | tee /dev/tty | grep -iq error && echo "Docker image ${image_id} created."
      else
        ! eval $build_cmd | grep -i error && echo "Docker image ${image_id} created."
      fi
    } || {
      echo
      echoError "ERROR: Docker image ${image_id} creation failed"
      exit 1
    }
  else
    echoBold "Not overwriting \"${image_id}\"..."
  fi
done

duration=$SECONDS
echoSuccess "Build process completed in $(($duration / 60)) minutes and $(($duration % 60)) seconds"
