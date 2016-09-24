#!/bin/env python3
import h5py
from numpy.random import randn

print('Creating Test Data')
mass = randn(10)
altitude = randn(10)
position = randn(10, 3)
velocity = randn(10, 3)

print('Write 1 dimensional arrays')
hdf5 = h5py.File('test1.hdf', 'w')
dataset = hdf5.create_dataset('test dataset', (10,),
                              dtype=[('mass', '<f8'),
                                     ('altitude', '<f8')])
dataset['mass'] = mass
dataset['altitude'] = altitude
hdf5.close()

print('Write 2 dimensional arrays')
hdf5 = h5py.File('test2.hdf', 'w')
dataset = hdf5.create_dataset('test dataset', (10,),
                              dtype=[('position', '<f8', 3),
                                     ('velocity', '<f8', 3)])
print(dataset['position'].shape)
print(position.shape)
dataset['position'] = position  # <-- Error Occurs Here
dataset['velocity'] = velocity
hdf5.close()
