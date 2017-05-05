#!/bin/bash -e
# Copyright 2016 C.S.I.R. Meraka Institute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

. /etc/profile.d/modules.sh
module add ci
module add ncurses
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
echo "installing ${NAME}"
export LDFLAGS="-Wl,-export-dynamic"

make install

echo "making module for ${NAME}"
mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}
module  add ncurses
module-whatis   "$NAME $VERSION."
setenv       READLINE_VERSION       $VERSION
setenv       READLINE_DIR           /data/ci-build/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH        $::env(READLINE_DIR)/lib
prepend-path PATH                   $::env(READLINE_DIR)/bin


MODULE_FILE
) > modules/${VERSION}

mkdir -p ${LIBRARIES}/${NAME}
cp modules/${VERSION} ${LIBRARIES}/${NAME}

module unload ci
echo "re-adding CI module"
module add ci
echo "is $NAME available ? "
module avail ${NAME}/${VERSION} # should have readline

echo "Adding ${NAME}"
module add ${NAME}

echo "what's in ${READLINE_DIR}/lib"
ls ${READLINE_DIR}/lib
echo "what's in ${READLINE_DIR}/include/readline ? "
ls ${READLINE_DIR}/include/readline
