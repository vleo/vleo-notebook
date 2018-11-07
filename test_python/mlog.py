"""
my logging module
easy to use logging:

import mlog
...
mlog.debug('test')
mlog.info('xyzzy')
...
"""
import logging
logging.basicConfig(style='{',format="{asctime:s}:{filename:s}:{lineno:d}:{msg:s}",level='DEBUG')
mlog=logging.getLogger(__name__)
debug=mlog.debug
info=mlog.info
__all__=['debug','info']
