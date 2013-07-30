#!/bin/bash

#     Created by Louis Teboul (a.k.a Androguide.fr) 
#     admin@androguide.fr
#     http://androguide.fr // http://pimpmyrom.org
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

BLUE="\\033[1;34m"
CYAN="\\033[1;36m"
RED="\\033[1;31m"
GREEN="\\033[1;32m"
YELLOW="\\e[93m"
BOLD="\\e[1m"
BLINK="\\e[5m"
RESET="\\e[0m"

while getopts ":sb" opt; do
	case $opt in sb)

echo -e "${GREEN} ${BLINK} ${BOLD}Running in silent-beast mode!!! (clean, timed build w/ 13 CPU threads) ${RESET}" >&2
make clobber
. build/envsetup.sh
lunch cm_i9300-userdebug
time mka bacon -j13
;;

\?)
echo -e "${RED}Invalid option: -$OPTARG  ${RESET}
${BLUE}Use -sb to run in silent-beast mode (clean & timed build w/ 13 CPU threads) ${RESET}
" >&2
;;
esac
done

echo -n -e "${CYAN}Clean build directory? ${BOLD}(Y/N) ${RESET}"; 
read input

if [ $input == Y ] || [ $input == y ] || [ $input == Yes ] || [ $input == yes ]; then
	make clobber
else
	echo -e "${YELLOW}WARNING: Leaving build directory intact.
	 Only the parts that were modified since last build will be rebuilt."
fi

echo -e "
${CYAN}Adding build tools & functions to the build environment... ${RESET}"
. build/envsetup.sh

echo -e "
${CYAN}Configuring Ubuntu build environment for Samsung Galaxy S3 (i9300)... ${RESET}"
lunch cm_i9300-userdebug

echo -n -e "${CYAN}How many CPU threads to build with? ${RESET}"
read threads

echo -e "${BLUE}Building with $threads CPU threads... ${RESET}
"

echo -n -e "${CYAN}Display build times when complete? ${BOLD}(Y/N) ${RESET}"
read timed

if [ $timed == Y ] || [ $timed == y ] || [ $timed == Yes ] || [ $timed == yes ]; then
    time mka bacon -j$threads
else
	mka bacon -j$threads
fi
