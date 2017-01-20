[![Build Status](https://ci.sagrid.ac.za/buildStatus/icon?job=readline-deploy)](https://ci.sagrid.ac.za/job/readline-deploy)

# readline-deploy

This contains the build, test and deploy scripts for the [GNU readline library](http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html) for CODE-RADE.

# Dependencies

  * ncurses [![Build Status](https://ci.sagrid.ac.za/buildStatus/icon?job=ncurses-deploy)](https://ci.sagrid.ac.za/job/ncurses-deploy/)

# Versions

The following versions are built in Foundation Release 3 :

  1. 6.3
  1. 7.0

# Configuration Options

The project is configured with :

```
../configure \
--enable-shared  \
--enable-static \
--with-curses \
--prefix ${SOFT_DIR}
```

# Citing
