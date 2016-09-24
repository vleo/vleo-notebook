import h5py
import numpy as np

f=h5py.File('test.hdf5','r+')

f.clear()

f.create_group('/model-uu321')

dts = np.dtype([('x','int'),('s','S10')])

ds= f.create_dataset('model-uu123/xyz',shape=(7,),dtype=dts,maxshape=(None))

ds.attrs['name']='xyzzy'

f.flush()

print(ds[0])

# can't assign to complex type
ds[0]['x']=123
ds[0]['s']='abc'

print(ds[0])

ds[0]=(123,'abc')

print(ds[0])

f.close()
