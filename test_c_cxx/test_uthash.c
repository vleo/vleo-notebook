#include <stdio.h>

#include <uthash/uthash.h>

struct my_struct {
    char* id;            /* we'll use this field as the key */
    char name[10];             
    UT_hash_handle hh; /* makes this structure hashable */
};

struct my_struct *users = NULL;

void add_user(struct my_struct *s) {
    HASH_ADD_KEYPTR(hh, users, s->id,strlen(s->id), s );    
}

struct my_struct *find_user(char* user_id) {
    struct my_struct *s;

    HASH_FIND_STR( users, user_id, s );  
    return s;
}

void delete_user(struct my_struct *user) {
    HASH_DEL( users, user);  
}

main(int argc,const char* argv[])
{
  struct my_struct a = { .id = "cat", .name="mary" };
  struct my_struct b = { .id = "lion", .name="john" };
  struct my_struct *c;
  
  add_user(&a);
  add_user(&b);

  c = find_user("lion");
  printf("%s\n",c ? c->name : "_NOT_FOUND_");
  delete_user(c);

  c = find_user("mary");
  printf("%s\n",c ? c->name : "_NOT_FOUND_");

  c = find_user("cat");
  printf("%s\n",c ? c->name : "_NOT_FOUND_");

  c = find_user("lion");
  printf("%s\n",c ? c->name : "_NOT_FOUND_");

  
}
