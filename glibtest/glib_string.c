#include <glib.h>

main()
{
  GString * myString1 =  g_string_new("Test string");
  GString * myString2 = g_string_new("");

  g_print("%s\n",myString1->str);

  g_string_insert(myString1,5,"inserted ");  
  g_string_append(myString1," appended");  
  g_string_prepend(myString1,"prepended ");  

  g_print("%s\n",myString1->str);

  g_string_assign(myString2,"ABCD");
  g_print("%s\n",myString2->str);
  
  g_string_overwrite(myString1,1,"XYZ");
  g_print("%s\n",myString1->str);

  g_string_erase(myString1,6,3);
  g_print("%s\n",myString1->str);
}
