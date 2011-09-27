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

void print_users(void) {
  struct my_struct *current;
  current=users;
  while(current != NULL) 
  {
    printf("user id %s: name %s\n", current->id, current->name);
    current=current->hh.next;
  }
}

main(int argc,const char* argv[])
{
  struct my_struct a = { .id = "cat", .name="mary" };
  struct my_struct b = { .id = "lion", .name="john" };
  struct my_struct c = { .id = "donkey", .name="james" };
  struct my_struct *x;
  
  add_user(&a);
  add_user(&b);
  add_user(&c);

  x = find_user("lion");
  printf("%s\n",x ? x->name : "_NOT_FOUND_");
  delete_user(x);

  x = find_user("mary");
  printf("%s\n",x ? x->name : "_NOT_FOUND_");

  x = find_user("cat");
  printf("%s\n",x ? x->name : "_NOT_FOUND_");

  x = find_user("donkey");
  printf("%s\n",x ? x->name : "_NOT_FOUND_");

  x = find_user("lion");
  printf("%s\n",x ? x->name : "_NOT_FOUND_");

  print_users();
}
