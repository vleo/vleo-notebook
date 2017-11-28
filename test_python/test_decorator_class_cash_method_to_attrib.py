class cached_property(object):
    """
    Decorator that converts a method with a single self argument into a
    property cached on the instance.

    Optional ``name`` argument allows you to make cached properties of other
    methods. (e.g.  url = cached_property(get_absolute_url, name='url') )
    """
    def __init__(self, func, name=None):
        print("func,name:",func,name)
        self.func = func
        self.__doc__ = getattr(func, '__doc__')
        self.name = name or func.__name__
        print(id(self))

    def __get__(self, instance, cls=None):
        print("instance,cls:",instance,cls)
        if instance is None:
            return self
        res = instance.__dict__[self.name] = self.func(instance)
        return res

class C():
  a = 123

  @cached_property
  def XYZ(self):
    print('calling XYZ')
    return self.a

c = C()
print(c.XYZ)
print(c.XYZ)
