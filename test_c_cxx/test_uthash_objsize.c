#include <uthash/uthash.h>
struct my_struct {
    char* id;            /* we'll use this field as the key */
    char name[10];             
    UT_hash_handle hh; /* makes this structure hashable */
};

struct my_struct *users = NULL;

void add_user(struct my_struct *s) {
//    HASH_ADD_KEYPTR(hh, users, s->id,strlen(s->id), s );    
}

int main(int argc,const char* argv[])
{
}
