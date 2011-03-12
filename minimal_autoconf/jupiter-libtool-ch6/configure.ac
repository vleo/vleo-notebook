#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.61])
AC_INIT([Jupiter], [1.0], [jupiter-bugs@example.org])
AM_INIT_AUTOMAKE
AM_SILENT_RULES([yes])
LT_PREREQ([2.2])
LT_INIT([dlopen win32-dll])
AC_SUBST([LIBTOOL_DEPS])
AC_LIBTOOL_WIN32_DLL

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_SRCDIR([src/main.c])
AC_CONFIG_HEADERS([config.h])

# Checks for programs.
AC_PROG_CC
AC_PROG_INSTALL
AM_PROG_CC_C_O

# Checks for command line options
AC_ARG_ENABLE([async-exec],
    [AS_HELP_STRING([--disable-async-exec],
        [disable asynchronous execution @<:@default: no@:>@])],
    [async_exec=${enableval}], [async_exec=yes])

AC_SEARCH_LIBS([pthread_create], [pthread], [have_pthreads=yes],AC_MSG_ERROR([pthreads library required]))
dnl if test "x${async_exec}" = xyes; then
dnl     have_pthreads=no
dnl     AC_SEARCH_LIBS([pthread_create], [pthread], [have_pthreads=yes])
dnl  
dnl      if test "x${have_pthreads}" = xyes; then
dnl          AC_CHECK_HEADERS([pthread.h], [], [have_pthreads=no])
dnl      fi
dnl  
dnl      if test "x${have_pthreads}" = xno; then
dnl          AC_MSG_WARN([
dnl    ------------------------------------------
dnl     Unable to find pthreads on this system.
dnl     Building a single-threaded version.
dnl    ------------------------------------------])
dnl          async_exec=no
dnl      fi
dnl  fi

if test "x${async_exec}" = xyes; then
    AC_DEFINE([ASYNC_EXEC], 1, [async execution enabled])
fi

# Checks for header files.
AC_CHECK_HEADERS([stdlib.h])
AC_CHECK_HEADERS([string.h])
AC_CHECK_HEADERS([ctype.h])
AC_CHECK_FUNCS(strdup, AC_DEFINE([HAVE_STRDUP]),AC_MSG_ERROR([strndup missing]))
AC_CHECK_FUNCS(strndup, AC_DEFINE([HAVE_STRNDUP]))

# Checks for libraries.
# Checks for typedefs, structures, and compiler characteristics.
# Checks for library functions.

AC_CONFIG_FILES([Makefile
                 common/Makefile
                 include/Makefile
                 libjup/Makefile
                 libjup1/Makefile
                 src/Makefile])
AC_OUTPUT

echo \
"-------------------------------------------------

 ${PACKAGE_NAME} Version ${PACKAGE_VERSION}

 Prefix: '${prefix}'.
 Compiler: '${CC} ${CFLAGS} ${CPPFLAGS}'

 Package features:
   Async Execution: ${async_exec}

 Now type 'make @<:@<target>@:>@'
   where the optional <target> is:
     all                - build all binaries
     install            - install everything

--------------------------------------------------"
