#include <stdio.h>
#include <rpc/rpc.h>
#define FIC "/tmp/test.xdr"

main ()
{
        FILE *fp;                  /*указатель файла */
        XDR xdrs;                  /*дескpиптоp XDR */
        long val1=10;              /*целое */
        float val2=4.456789;       /*с плавающей точкой */
        char val3s[] = "qwerty123456uvwxyz"; /* 18+1 bytes null terminated string */
        char *val3;
        int r;
        val3 = malloc(20);
        strcpy(val3,val3s);
/*откpытие файла на запись */
        fp = fopen(FIC, "w");
/*      создание потока XDR для кодиpования */
        xdrstdio_create(&xdrs, fp, XDR_ENCODE);
/*запись целого */
        xdr_long(&xdrs, &val1);
/*запись числа с плавающей точкой */
        xdr_float(&xdrs, &val2);
/* write string */
        r = xdr_string(&xdrs, &val3, strlen(val3));
        printf("r=%d\n",r);
        free(val3);
        fclose(fp);
        exit(0);
}
