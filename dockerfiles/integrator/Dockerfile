# ------------------------------------------------------------------------
#
# Copyright 2017 WSO2, Inc. (http://wso2.com)
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
#
# ------------------------------------------------------------------------

# set to product base image
FROM wso2ei-base:6.1.1

# set user configurations
ARG USER=wso2carbon
ARG USER_HOME=/home/${USER}
# set dependant libs directory
ARG LIB=./lib/*
# set wso2 product configurations
ARG WSO2_SERVER=wso2ei
ARG WSO2_SERVER_VERSION=6.1.1
ARG WSO2_SERVER_DIST=${WSO2_SERVER}-${WSO2_SERVER_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER_DIST}

COPY --chown=wso2carbon:wso2 ${LIB} ${WSO2_SERVER_HOME}/lib/

# expose integrator ports
EXPOSE 8280 8243 9443

# set entrypoint to integrator startup script
ENTRYPOINT ${WSO2_SERVER_HOME}/bin/integrator.sh
