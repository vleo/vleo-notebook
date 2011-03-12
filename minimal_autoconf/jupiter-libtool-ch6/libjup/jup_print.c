#include "libjupiter.h"
#include "libjupiter1.h"
#include "jupcommon.h"

int jupiter_print(const char * name)
{
    print_routine(upcaseName(name));
}
