import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.widgets as mpw

fig = plt.figure(1,(8,2))

axes = fig.add_axes((0.1,0.3,0.8,0.3),axisbg="g")

sld = mpw.Slider(axes,"Tau",0.0,1.0,valinit = 0.3) #,valfmt = "%+04.1f")
sld.valtext.set_visible(False)

fig.show()
input('press ENTER to exit')
plt.get_current_fig_manager().destroy()
