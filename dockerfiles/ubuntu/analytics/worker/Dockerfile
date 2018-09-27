# ------------------------------------------------------------------------
#
# Copyright 2018 WSO2, Inc. (http://wso2.com)
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
FROM wso2ei-base:6.4.0
ARG FILES=./files

# copy entrypoint bash script to user home
COPY --chown=wso2carbon:wso2 init.sh ${WORKING_DIRECTORY}/
COPY --chown=wso2carbon:wso2 ${FILES}/mysql-connector-java-*-bin.jar ${WSO2_SERVER_HOME}/wso2/analytics/lib/

# expose analytics ports
EXPOSE 9444 7612 7712 9161

# set entrypoint to init script
ENTRYPOINT ["/home/wso2carbon/init.sh"]
