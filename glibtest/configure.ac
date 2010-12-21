AC_PREREQ(2.53)

#xyzzy version
m4_define(xyzzy_major_version, 0)
m4_define(xyzzy_minor_version, 0)
m4_define(xyzzy_micro_version, 1)
m4_define(xyzzy_version, xyzzy_major_version.xyzzy_minor_version.xyzzy_micro_version)

AC_INIT(xyzzy, xyzzy_version, vleolml@gmail.com, [xyzzy])

# require automake-1.11 for vala support
AM_INIT_AUTOMAKE([1.11 dist-bzip2])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])
AM_MAINTAINER_MODE

# Disable generation of static libraries
AC_DISABLE_STATIC

dnl required versions for xyzzy
GLIB_REQUIRED=2.22.0
GTHREAD_REQUIRED=2.0

AC_PROG_CC

AC_STDC_HEADERS
AC_PROG_LIBTOOL
AC_FUNC_MMAP

PKG_CHECK_MODULES(XYZZY, \
    glib-2.0 >= $GLIB_REQUIRED \
    gthread-2.0 >= $GTHREAD_REQUIRED \
    )

XYZZY_PACKAGES="\
    --pkg config \
    --pkg posix \
    --pkg taglib_c \
    --pkg linux \
"

AC_SUBST(XYZZY_CFLAGS)
AC_SUBST(XYZZY_LIBS)
AC_SUBST(XYZZY_PACKAGES)

dnl Shave the output
AM_SILENT_RULES([yes])

AC_CONFIG_FILES([
    Makefile
])

AC_OUTPUT

echo "
  ${PACKAGE} ${VERSION}
  ~~~~~~~~~~~~
  
  Configuration Info:
    prefix:                        ${prefix}
    CFLAGS:                        ${CFLAGS}

"
