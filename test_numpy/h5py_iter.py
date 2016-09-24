def h5py_iter(g,prefix=''):
  for key in g.keys():
    item = g[key]
    path = '{}/{}'.format(prefix, key)
    if isinstance(item, h5py.Dataset): # test for dataset
      yield (path, item)
    elif isinstance(item, h5py.Group): # test for group (go down)
      yield from h5py_iter(item, path)

