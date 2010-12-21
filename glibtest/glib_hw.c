#include <glib.h>

main()
{
  g_print("GLIB_MAJOR_VERSION:%d GLIB_MINOR_VERSION:%d GLIB_MICRO_VERSION:%d\n",
           GLIB_MAJOR_VERSION, GLIB_MINOR_VERSION, GLIB_MICRO_VERSION);

g_print("\nmajor should match\n");
  const gchar* retv =
    glib_check_version  (GLIB_MAJOR_VERSION-1,
                         GLIB_MINOR_VERSION,
                         GLIB_MICRO_VERSION);
  if (retv) g_print("%s\n",retv);

g_print("\nminor and micro can be less then ones compiled for\n");
  retv =
    glib_check_version  (GLIB_MAJOR_VERSION,
                         GLIB_MINOR_VERSION-1,
                         GLIB_MICRO_VERSION-1);
  if (retv) g_print("%s\n",retv);


g_print("\nminor and micro can not be more then compiled for\n");
  retv =
    glib_check_version  (GLIB_MAJOR_VERSION,
                         GLIB_MINOR_VERSION,
                         GLIB_MICRO_VERSION+1);
  if (retv) g_print("%s\n",retv);
}

