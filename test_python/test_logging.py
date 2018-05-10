#!/usr/bin/env python3
from pudb import set_trace
import logging
from zenlog import log
from sys import argv

#set_trace()

try:
  argv[1]
except IndexError:
  print("Usage: test_logging.py [zen|basic|easy|full]")
  exit(1)


def myMain():
  x=input('Enter x:')

  if argv[1] == 'zen':
    log.level('info')
    log.d('debug')
    log.i('info x={}'.format(x))
    log.w('warn')
    log.e('error')
    log.c('critical')
  else:
    if argv[1] == 'basic':
    # see Python Docs logging.html 16.6.7. LogRecord attributes
      logging.basicConfig(style='{',format="{asctime:s}:{filename:s}:{lineno:d}:{msg:s}",level='DEBUG')
      logging.debug('our debug message x={}'.format(x))
      logging.warn('our warn message x={}'.format(x))

    else:
      print("If we don't want to type logging.debug() etc, we have to create our own logger lg=logging.getLogger({})".format(__name__))
      lg=logging.getLogger(__name__)

      if argv[1]=='easy':
        logging.basicConfig(level='INFO')
      else:
        lg.setLevel('WARN') # optional: defaults to all levels
        lg.addHandler(logging.StreamHandler())
        lg.handlers[0].setFormatter(logging.Formatter(style='{',fmt="{filename:s}:{funcName:s}():{lineno:d}:{msg:s}"))

      lg.debug('our debug mesage')
      lg.info('our info here')

myMain()
