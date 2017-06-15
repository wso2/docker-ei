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

# If MODULE_NAME is not set in Dockerfile, set it to WSO2_SERVER
if [[ -z "$MODULE_NAME" ]]; then
  MODULE_NAME=$WSO2_SERVER
fi

# Export facter variables
export FACTER_product_name=${MODULE_NAME}
export FACTER_product_version=${WSO2_SERVER_VERSION}
export FACTER_product_profile=${WSO2_SERVER_PROFILE}
export FACTER_environment=${WSO2_ENVIRONMENT}
export FACTER_platform=${PLATFORM}
export FACTER_vm_type=docker
export FACTER_use_hieradata=true
export FACTER_pattern=pattern-${WSO2_DEPLOYMENT_PATTERN}

echo "Facters used: "
echo -e "\t- product_name=${FACTER_product_name}"
echo -e "\t- product_version=${FACTER_product_version}"
echo -e "\t- product_profile=${FACTER_product_profile}"
echo -e "\t- environment=${FACTER_environment}"
echo -e "\t- platform=${FACTER_platform}"
echo -e "\t- vm_type=${FACTER_vm_type}"
echo -e "\t- use_hieradata=${FACTER_use_hieradata}"
echo -e "\t- pattern=${FACTER_pattern}"

# Prepare Puppet
mkdir -p /etc/puppet
pushd /etc/puppet > /dev/null

# Add wso2user
getent group wso2 > /dev/null 2>&1 || addgroup wso2
id -u wso2user > /dev/null 2>&1 || adduser --system --shell /bin/bash --gecos 'WSO2User' --ingroup wso2 --disabled-login wso2user

# Download Puppet modules and Hiera files via local Python HTTP server
echo "Downloading Puppet modules and Hiera data..."
wget -q -nv -rnH -e robots=off --reject "index.html*" ${HTTP_PACK_SERVER}/hiera.yaml
wget -q -nv -rnH --level=0 -e robots=off --reject "index.html*" ${HTTP_PACK_SERVER}/hieradata/
wget -q -nv -rnH --level=0 -e robots=off --reject "index.html*" ${HTTP_PACK_SERVER}/manifests/
wget -q -nv -rnH --level=0 -e robots=off --reject "index.html*" ${HTTP_PACK_SERVER}/modules/wso2base/
wget -q -nv -rnH --level=0 -e robots=off --reject "index.html*" ${HTTP_PACK_SERVER}/modules/${MODULE_NAME}/

# Run Puppet agent in stand-alone mode
echo "Running Puppet agent..."
puppet apply /etc/puppet/manifests/site.pp --hiera_config=/etc/puppet/hiera.yaml

# Cleanup
echo "Cleaning up packages and files no longer required..."
apt-get purge -y --auto-remove puppet wget zip unzip
rm -rf /etc/puppet/*
rm -rf /var/lib/apt/lists/*
chown wso2user:wso2 /usr/local/bin/*
chown -R wso2user:wso2 /mnt
popd > /dev/null
