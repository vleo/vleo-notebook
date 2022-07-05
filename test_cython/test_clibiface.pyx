cdef extern from "stdint.h":
    ctypedef unsigned long long uintptr_t

cdef extern from "stdlib.h":
  int atoi(const char *nptr)

#  ctypedef struct CLIENT:
#    pass

#  CLIENT *clnt_create (const char *host,
#                       const u_long prog,
#                       const u_long vers,
#                       const char *prot) 

#  struct hostInfoBuf:
#      u_int nMCUs
#      char *hostMAC_s


from libc.stdlib cimport free
from cpython cimport PyObject, Py_INCREF

def py_atoi(intstr):
  istr = bytearray(intstr,'utf-8')
  intval = atoi(istr)
  return intval
