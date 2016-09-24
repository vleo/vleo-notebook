#include <stdio.h>
#include <rpc/rpc.h>
#define FIC "/tmp/test.xdr"

main()

{
        FILE *fp;                  /*указатель файла */
        XDR xdrs;                  /*дескpиптоp XDR */
        long val1;                 /*целое */
        float val2;                /*с плавающей точкой */
        char *val3;
        // val3=malloc(20);
        /* request auto-allocation of result string */
        val3=NULL;

/*откpытие файла на считывание */
        fp = fopen(FIC, "r");
/*создание потока XDR для декодиpования */
        xdrstdio_create(&xdrs, fp, XDR_DECODE);
/*считывание целого числа */
        xdr_long(&xdrs, &val1);
/*считывание числа с плавающей точкой */
        xdr_float(&xdrs, &val2);
        xdr_string(&xdrs,&val3,20);
        printf("%ld %f %s\n",val1,val2,val3);
        /* be sure to free auto-allocated buffer */
        free(val3);
        fclose(fp);
        exit(0);
}
