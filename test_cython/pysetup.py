from distutils.core import setup,Extension
from Cython.Build import cythonize
import os

basename= os.environ["BASENAME"]

extList= [Extension(
  name=basename,
  sources= [basename+".pyx"],
)]


setup( ext_modules = cythonize(extList) )

