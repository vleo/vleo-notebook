#!/usr/bin/python
# -*- coding: utf-8 -*-

from setupcon import setup_console
setup_console('utf-8', False)
#...

# или если будем пользоваться раскрашиванием логов
import setupcon
setupcon.setup_console()
import logging
#...
if setupcon.ansi:
    logging.getLogger().addHandler(setupcon.ColoredHandler())

print 'Федор'
