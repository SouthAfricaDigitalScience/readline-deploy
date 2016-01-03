#!/bin/bash -e
. /etc/profile.d/modules.sh
module load ci
cd ${WORKSPACE}/${NAME}-${VERSION}
echo "installing ${NAME}"

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

module-whatis   "$NAME $VERSION."
setenv       READLINE_VERSION       $VERSION
setenv       READLINE_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(READLINE_DIR)/lib
MODULE_FILE
) > modules/${VERSION}

mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}

module unload ci

module add ci
module avail # should have ncurses
module add ${NAME}
