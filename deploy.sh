#!/bin/bash -e
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
make all
make install
echo "making deploy modules"
mkdir -p ${LIBRARIES_MODULES}/${NAME}

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
) > ${LIBRARIES_MODULES}/${NAME}/${VERSION}
