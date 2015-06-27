#coding:utf-8

import _env
from os.path import join, abspath, dirname
try:
    from yajl import dumps
except ImportError:
    from json import dumps

import traceback
from monitor import Monitor 
from os import walk
from distutils.dir_util import mkpath
from _import import _import

PATH = join(_env.PREFIX, 'rpc')

def monitor_fake_rpc_init():
    Monitor.add_watch.send(PATH)
    for dirpath, dirnames, filenames in walk(abspath(PATH)):
        for filename in filenames:
            if filename.endswith(".join.py"):
                path = join(dirpath, filename)
                compile(path)

def compile(path):
    route = {}
    try:
        execfile(path, route)
    except:
        traceback.print_exc()
        return 
    if 'FAKE' in route:
        basepath = path[len(PATH)+1:-7]
        basepath = join(_env.PREFIX,"build/rpc",basepath)

        for k,v in route['FAKE'].__dict__.iteritems():
            if k.startswith("_"):
                continue
            filepath = basepath+k
            mkpath(dirname(filepath))
            with open(filepath,"w") as f:
                print dirname(filepath)
                f.write(dumps(v))

@Monitor.notify.connect
def _(filename):
    if not filename.endswith('.json.py'):
        return
    compile(filename)

