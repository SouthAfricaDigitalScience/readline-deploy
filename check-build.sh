#!/bin/bash -e
. /etc/profile.d/modules.sh
module load ci
module add ncurses
cd ${WORKSPACE}/${NAME}-${VERSION}
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
setenv       READLINE_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH        $::env(READLINE_DIR)/lib
prepend-path PATH                   $::env(READLINE_DIR)/bin


MODULE_FILE
) > modules/${VERSION}

mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}

module unload ci

module add ci
module avail # should have readline
module add ${NAME}
ls ${READLINE_DIR}/lib
ls ${READLINE_DIR}/include/readline
