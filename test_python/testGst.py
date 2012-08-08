import pygst

class Player: 
    def __init__(self):
        self.player = gst.element_factory_make("playbin2", "player")
        self.bus = self.player.get_bus()

