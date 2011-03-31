extern int foo[2];
__attribute__((cold))
int bar(void)
{
    return foo[1];
}
