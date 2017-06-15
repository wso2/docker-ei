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

# Define error handling function
function error_handler() {
  MYSELF="$0"       # equals to script name
  LASTLINE="$1"     # argument 1: last line of error occurence
  LASTERR="$2"      # argument 2: error code of last command
  echo "ERROR in ${MYSELF}: line ${LASTLINE}: exit status of last command: ${LASTERR}"
  exit 1
}

# Execute error_handler function on script error
trap 'error_handler ${LINENO} $?' ERR

# Replaces localMemberHost element value in axis2.xml file with $1
# $1 - hostname
# $2 - axis2.xml file path
function replace_local_member_host() {
  sed -i "s#<parameter\ name=\"localMemberHost\".*#<parameter\ name=\"localMemberHost\">${1}<\/parameter>#" "${2}"
  if [[ $? == 0 ]]; then
    echo "Successfully updated localMemberHost with ${1}"
  else
    echo "Error occurred while updating localMemberHost with ${1}"
  fi
}

# Replaces localMemberPort element value in axis2.xml file with $1
# $1 - port
# $2 - axis2.xml file path
function replace_local_member_port() {
  sed -i "s#<parameter\ name=\"localMemberPort\".*#<parameter\ name=\"localMemberPort\">${1}<\/parameter>#" "${2}"
  if [[ $? == 0 ]]; then
    echo "Successfully updated localMemberPort with ${1}"
  else
    echo "Error occurred while updating localMemberPort with ${1}"
  fi
}

function main() {
  echo "Initializing ${WSO2_SERVER}-${WSO2_SERVER_VERSION} in ${WSO2_SERVER_PROFILE} profile on ${PLATFORM} platform..."
  # Helps to handle dependencies among containers when running on bare metal mode
  if [ ! -z $SLEEP ];then
    echo "Going to sleep for ${SLEEP}s..."
    sleep $SLEEP
  fi

  PRGDIR=$(dirname "$0")
  SCRIPT_PATH=$(cd "$PRGDIR"; pwd)
  export LOCAL_DOCKER_IP=$(ip route get 1 | awk '{print $NF;exit}')
  SERVER_NAME="${WSO2_SERVER}-${WSO2_SERVER_VERSION}"
  WSO2_ARTIFACTS_DIR='/mnt/wso2-artifacts'
  INSTALL_PATH="/mnt/${SERVER_NAME}"
  PASSWORD_TMP_FILE="${INSTALL_PATH}/password-tmp"
  if [ "$WSO2_SERVER_PROFILE" = "analytics" ]; then
    AXIS2_XML_FILE="${INSTALL_PATH}/wso2/analytics/conf/axis2/axis2.xml"
    SECRET_CONF_PROPERTIES_FILE="${INSTALL_PATH}/wso2/analytics/conf/security/secret-conf.properties"
  elif [ "$WSO2_SERVER_PROFILE" = "business-process" ]; then
    AXIS2_XML_FILE="${INSTALL_PATH}/wso2/business-process/conf/axis2/axis2.xml"
    SECRET_CONF_PROPERTIES_FILE="${INSTALL_PATH}/wso2/business-process/conf/security/secret-conf.properties"
  elif [ "$WSO2_SERVER_PROFILE" = "broker" ]; then
    AXIS2_XML_FILE="${INSTALL_PATH}/wso2/broker/conf/axis2/axis2.xml"
    SECRET_CONF_PROPERTIES_FILE="${INSTALL_PATH}/wso2/broker/conf/security/secret-conf.properties"
  else
    AXIS2_XML_FILE="${INSTALL_PATH}/conf/axis2/axis2.xml"
    SECRET_CONF_PROPERTIES_FILE="${INSTALL_PATH}/conf/security/secret-conf.properties"
  fi


  if [[ $PLATFORM == "mesos" ]]; then
    # Replace localMemberHost with host IP so that it is reachable via containers in other hosts
    # This is needed for Hazelcast based clustering to work when bridge mode Docker networking is used (eg: Mesos with Marathon)
    replace_local_member_host $HOST $AXIS2_XML_FILE
    # Replace localMemberPort with dynamically generated port by Marathon which will be used for Hazelcast communication
    replace_local_member_port $PORT0 $AXIS2_XML_FILE
  else
    # Replace localMemberHost with local Docker IP address
    # This is needed for Hazelcast based clustering to work when HOST mode Docker networking is used with an overlay network (eg: Kubernetes with flanneld)
    replace_local_member_host $LOCAL_DOCKER_IP $AXIS2_XML_FILE
  fi

  CARBON_HOME="/mnt/${SERVER_NAME}"
  source /etc/profile.d/set_java_home.sh

  if [[ ! -z $KEY_STORE_PASSWORD ]]; then
    # adding key-store-password to password-tmp file
    touch $PASSWORD_TMP_FILE
    echo "$KEY_STORE_PASSWORD" > $PASSWORD_TMP_FILE
  fi

  if [[ -d $WSO2_ARTIFACTS_DIR ]]; then
    echo "Copying artifacts in ${WSO2_ARTIFACTS_DIR} to ${CARBON_HOME}"
    cp -r ${WSO2_ARTIFACTS_DIR}/* $CARBON_HOME
  fi

# this is deprecated, use /mnt/wso2-artifacts instead.
  artifact_dir='/mnt/wso2/carbon-home'
  if [[ -d ${artifact_dir} ]]; then
    echo "Copying artifacts in ${artifact_dir} to ${CARBON_HOME}"
    cp -r ${artifact_dir}/* ${CARBON_HOME}
  fi

  # Search for a bash script file in format: <product_name>-<profile_name>-init.sh
  # Execute that before starting the server. This is a pluggable extension point
  PRODUCT_INIT_SCRIPT_FILE="${SCRIPT_PATH}/${WSO2_SERVER}-${WSO2_SERVER_PROFILE}-init.sh"
  if [[ -f $PRODUCT_INIT_SCRIPT_FILE ]]; then
    echo "Running init extension script found in ${PRODUCT_INIT_SCRIPT_FILE}"
    bash $PRODUCT_INIT_SCRIPT_FILE || {
      echo "Non-zero exit code returned from init extension script. Failed to start server. Aborting..."
      exit $?
    }
  fi

  # if DEBUG is specified, run server in debug mode
  if [ ! -z ${DEBUG} ] ;then
    echo "Debug mode is enabled on port: ${DEBUG}"
    STARTUP_ARGS+=" -debug ${DEBUG}"
  fi

  echo "Starting ${SERVER_NAME} with [Startup Args] ${STARTUP_ARGS}, [CARBON_HOME] ${CARBON_HOME}"
  if [ "$WSO2_SERVER_PROFILE" = "analytics" ]; then
    ${CARBON_HOME}/bin/analytics.sh $STARTUP_ARGS
  elif [ "$WSO2_SERVER_PROFILE" = "business-process" ]; then
    ${CARBON_HOME}/bin/business-process.sh $STARTUP_ARGS
  elif [ "$WSO2_SERVER_PROFILE" = "broker" ]; then
    ${CARBON_HOME}/bin/broker.sh $STARTUP_ARGS
  else
    ${CARBON_HOME}/bin/integrator.sh $STARTUP_ARGS
  fi
}
main
