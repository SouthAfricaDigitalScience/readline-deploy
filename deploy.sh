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

# this should be run after check-build finishes.
. /etc/profile.d/modules.sh
module add deploy
module add ncurses
# Now, dependencies
echo ${SOFT_DIR}
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
rm -rf *
echo "All tests have passed, will now build into ${SOFT_DIR}"
export LDFLAGS="-Wl,-export-dynamic"

../configure \
--enable-shared \
--enable-static \
--with-curses \
--prefix=${SOFT_DIR}
echo "making install"
make
make shared
make install
echo "making deploy modules"
mkdir -p ${LIBRARIES}/${NAME}

# Now, create the module file for deployment
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}
module add ncurses
module-whatis   "$NAME $VERSION : See https://github.com/SouthAfricaDigitalScience/readline-deploy"
setenv       READLINE_VERSION       $VERSION
setenv       READLINE_DIR           $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH        $::env(READLINE_DIR)/lib
prepend-path PATH                   $::env(READLINE_DIR)/bin
MODULE_FILE
) > ${LIBRARIES}/${NAME}/${VERSION}

module add ${NAME}/${VERSION}

echo "what's in ${READLINE_DIR}/lib"
ls ${READLINE_DIR}/lib
echo "what's in ${READLINE_DIR}/include/readline ? "
ls ${READLINE_DIR}/include/readline
