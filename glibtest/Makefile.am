NULL =

bin_PROGRAMS = glibhw glibthread glibstring

INCLUDES = \
	-include $(CONFIG_HEADER) \
	$(XYZZY_CFLAGS) \
	$(NULL)

#glibstring_HEADERS = glibstring.h

BUILT_SOURCES = \
	glib_string.c \
	glib_hw.c \
	glib_threads.c \
	$(NULL)

glibhw_SOURCES = \
	glib_hw.c \
	$(NULL)

glibthread_SOURCES = \
	glib_threads.c \
	$(NULL)

glibstring_SOURCES = \
	glib_string.c \
	$(NULL)

glibhw_LDADD = \
	$(XYZZY_LIBS) \
	$(NULL)

glibthread_LDADD = \
	$(XYZZY_LIBS) \
	$(NULL)

glibstring_LDADD = \
	$(XYZZY_LIBS) \
	$(NULL)

glibhw_LDFLAGS = -export-dynamic
glibthread_LDFLAGS = -export-dynamic
glibstring_LDFLAGS = -export-dynamic

MAINTAINERCLEANFILES = Makefile.in $(BUILT_SOURCES)

EXTRA_DIST = \
	$(BUILT_SOURCES) \
	$(NULL)

DISTCLEANFILES = \
	*.o \
	Makefile.in \
	$(NULL)

