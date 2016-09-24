# v1 should be changeable only through GUI

def pr():
    print(view.vv, model.vv)
    print('-'*20)

# metaclass for wireable objects
class wirevarMeta(type):
    def __new__(meta,name,parents,dct):
        #print(meta,name,parents,dct)
        def new_init(self,*args,**kwargs):
            orig_init(self,*args,**kwargs)
            self.init_wirevars()
        def new_init0(self,*args,**kwargs):
            self.init_wirevars()
        if '__init__' in dct:
            orig_init = dct['__init__']
            dct['__init__']=new_init
        else:
            dct['__init__']=new_init0

        dct['vv']={}
        dct['get_wirevars']=meta.get_wirevars
        dct['init_wirevars']=meta.init_wirevars
        return super().__new__(meta, name, parents, dct)

    def get_wirevars(instance):
        c=instance.__class__
        d=c.__dict__
        return { v:getattr(c, v) for v in d.keys() if isinstance(d[v], wirevar)}

    def init_wirevars(instance):
        for vk,v in instance.get_wirevars().items():
            if vk not in instance.vv:
                instance.vv[vk]=v.default


# decorator for wireable class variables
class wirevar:
    def __init__(self,default=None):
        self.default = default
        #print('creating desctiptor ', default)
    def __call__(self,f):
        #print('descriptor name:', f.__name__)
        self.name = f.__name__
        self.cb_on_change=f
        self.on_change=Wireable.cb_pass
        return self
    def __get__(self, instance, owner):
        if instance is None:
            return self
        return instance.vv[self.name] if self.name in instance.vv else self.default
        #getattr(instance,self.name,self.default)
    def __set__(self, instance, value):
        instance.vv[self.name] = value
        self.on_change(instance, value)
        #setattr(instance,self.name,value)
    def get_on_change_cb(self,instance):
        return self.on_change

class Wireable(metaclass=wirevarMeta):
    @staticmethod
    def cb_pass(*args): pass

    def connect(self, view):
        vw = view.get_wirevars()
        mw = self.get_wirevars()
        for (vk,v) in vw.items():
            if vk in mw.keys():
                vw[vk].on_change = mw[vk].cb_on_change
        for (vk,v) in mw.items():
            if vk in vw.keys():
                mw[vk].on_change = vw[vk].cb_on_change
        view.vv = self.vv

    def disconnect(self, view):
        for v in view.get_wirevars().values():
            v.on_change = self.cb_pass
        for v in self.get_wirevars().values():
            v.on_change = self.cb_pass
        view.vv = dict(view.vv)

class View(Wireable):
    @wirevar(321)
    def v1(self,v):
        print('view: v1 change: ', v)

    @wirevar(123)
    def v2(self,v):
        print('view: v2 change: ', v)

class Model(Wireable):

    @wirevar(666)
    def v1(self,v):
        print('model: v1 change: ', v)

    @wirevar(777)
    def v2(self,v):
        print('model: v2 change: ', v)


#exit()
print('-'*20)
view = View()
model = Model()
pr()

model.connect(view)
pr()

view.v1 = 10
pr()

model.v1 = 11
pr()

print('-'*20)
view.v2 = 999
model.v2 = 666
model.disconnect(view)
view.v2 = 777
model.v1 = 12
pr()
print(view.get_wirevars())
