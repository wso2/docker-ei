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

product_name=wso2ei
product_version=6.1.1

prgdir=$(dirname "$0")
script_path=$(cd "$prgdir"; pwd)
common_folder=$(cd "${script_path}/common/scripts/"; pwd)

# Ports mapping standalone mode
#+------------------+-------------+------------------------------------+
#|     Profile      | port offset |             Bind Ports             |
#+------------------+-------------+------------------------------------+
#| integrator       |           0 |                8280 8243 9763 9443 |
#| analytics        |           1 |      9612 9712 7712 7612 9764 9444 |
#| business-process |           2 |                          9765 9445 |
#| broker           |           3 | 1886 8886 5675 8675 7614 9766 9446 |
#+------------------+-------------+------------------------------------+

#  Ports mapping cluster mode
#+------------------+-------------+------------------------------------+
#|     Profile      | port offset |             Bind Ports             |
#+------------------+-------------+------------------------------------+
#| integrator       |           0 |                8280 8243 9763 9443 |
#| analytics        |           0 |      9611 9711 7711 7611 9763 9443 |
#| business-process |           0 |                          9763 9443 |
#| broker           |           0 | 1883 8883 5672 8672 7611 9763 9443 |
#+------------------+-------------+------------------------------------+

bash ${common_folder}/docker-run.sh -n ${product_name} -v ${product_version} -p 8280:8280 -p 8243:8243 -p 9763:9763 -p 9443:9443 -p 9612:9612 -p 9712:9712 -p 7712:7712 -p 7612:7612 -p 9764:9764 -p 9444:9444 -p 9765:9765 -p 9445:9445 -p 1886:1886 -p 8886:8886 -p 5675:5675 -p 8675:8675 -p 7614:7614 -p 9766:9766 -p 9446:9446 -p 9611:9611 -p 9711:9711 -p 7711:7711 -p 7611:7611 -p 1883:1883 -p 8883:8883 -p 5672:5672 -p 8672:8672 $*
