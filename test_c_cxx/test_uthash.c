#include <stdio.h>

#include <uthash.h>

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
  printf("***iterate over hash using the 'while' cycle***\n");
  while(current != NULL) 
  {
    printf("user id %s: name %s\n", current->id, current->name);
    current=current->hh.next;
  }
}

char* find_id_by_name(char* name) {
  struct my_struct *current, *tmp;

  HASH_ITER(hh, users, current, tmp)
    if (!strcmp(current->name,name))
      break;

  return current ? current->id : NULL;
}

main(int argc,const char* argv[])
{
  struct my_struct a = { .id = "cat", .name="mary" };
  struct my_struct b = { .id = "lion", .name="john" };
  struct my_struct c = { .id = "donkey", .name="james" };
  struct my_struct *x;
  char* id;
  
  add_user(&a);
  add_user(&b);
  add_user(&c);

  printf("\n  List hash items:\n");
  print_users();

  printf("\n  Forward lookup:\n");
  x = find_user("lion");
  printf("lion -> %s\n",x ? x->name : "_NOT_FOUND_");
  printf("\n  delete lion\n");
  delete_user(x);

  printf("\n  Forward lookup:\n");
  x = find_user("mary");
  printf("mary -> %s\n",x ? x->name : "_NOT_FOUND_");

  x = find_user("cat");
  printf("cat ->  %s\n",x ? x->name : "_NOT_FOUND_");

  x = find_user("donkey");
  printf("donkey -> %s\n",x ? x->name : "_NOT_FOUND_");

  x = find_user("lion");
  printf("lion -> %s\n",x ? x->name : "_NOT_FOUND_");

  printf("\n  Reverse lookup:\n");

  id = find_id_by_name("mary");
  printf("%s <- mary\n",id ? id : "_NOT_FOUND_");

  id = find_id_by_name("james");
  printf("%s <- james\n",id ? id : "_NOT_FOUND_");

  id = find_id_by_name("piggy");
  printf("%s <- piggy\n",id ? id : "_NOT_FOUND_");


}
