AC_INIT([helloworld], [1.0], [vleo@linuxmedialabs.com])
AM_INIT_AUTOMAKE([-Wall -Werror foreign nostdinc])

AC_ARG_ENABLE(
  [debug],
  [  --enable-debug   Enbale gdb debugging ],
  [ debug=true
    AC_DEFINE([DEBUG],[Ug],[DebUg mode])
    AC_SUBST([DEBUGS],[uG],[defined DEBUGS variable in Makefile])
    CFLAGS+="-ggdb3 -DDEBUG"
    ],
  [debug=false])

AC_DEFINE_UNQUOTED([PREFIX],"$prefix",[install path (--prefix)])

AC_PROG_CC
AC_PROG_LIBTOOL

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([Makefile])

AC_OUTPUT
