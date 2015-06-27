#!/usr/bin/env python
#coding:utf-8
import _env
import envoy

from distutils.dir_util import mkpath
from os.path import join, dirname, isdir, abspath, basename, islink, exists,getmtime
from dirwalk import walk
from extract import extract_all
# import sys
# from tempfile import mkdtemp
# from hashlib import md5
# from collections import defaultdict
from shutil import copy
# from os import makedirs as _makedirs, remove
from shutil import rmtree
from collections import defaultdict
from monitor import Monitor

PLIM_MAP = defaultdict(set)
PLIM_PATH = join(_env.PREFIX, 'plim')

HG_IGNORE = set()


def compile_all(filename):
    filename = _basename(filename)
    to_compile = set()
    to_compile_list = []
    def _complie(path):
        for i in PLIM_MAP[path]:
            if i == filename:
                continue
            if i not in to_compile:
                to_compile.add(i)
                to_compile_list.append(i)
                _complie(i)
    _complie(filename)
    for i in to_compile_list:
        compile(join(PLIM_PATH,i+".plim")) 
    

def plim_map(filename):

    with open(filename, 'r') as infile:

        html = infile.read()
        for i in extract_all('"', '.plim"', html)+extract_all("'", ".plim'", html)+extract_all(' ', '.plim', html):
            if not i.startswith('/'):
                base = dirname(filename)
                i = abspath(join(base, i))[len(PLIM_PATH)+1:]
            else:
                i = i[1:]
            PLIM_MAP[i].add(filename[len(PLIM_PATH)+1:-5])

def _basename(filename):
    if filename.find(PLIM_PATH) >= 0:
        basename = filename[len(PLIM_PATH)+1:-5]
    else:
        basename = filename[len(_env.PREFIX)+1:-5]
    return basename

def compile(filename,  html=True, print_path=True):
    plim_map(filename)
    basename = _basename(filename)

    if print_path:
        print basename+'.plim'


    if '/_' not in '/'+basename:
        html_path = join(_env.PREFIX, 'pure/html', basename+'.html')
        mkpath(dirname(html_path))
        cmd = 'plimc -H %s -o %s --root %s'%(basename+".plim" , html_path, PLIM_PATH)
        r = envoy.run(cmd)
        if r.std_out.strip():
            print r.std_out
        if r.std_err.strip():
            print cmd
            print r.std_err



def monitor_plim_init():

    Monitor.add_watch.send(PLIM_PATH) 
    r = []

    print 'COMPLIE PLIM'

    for pos, (dirpath, dirnames, filenames) in enumerate(walk(abspath(PLIM_PATH)), 1):
        for f in filenames:
            print f
            if f.endswith('.plim'):
                fpath = join(dirpath, f)
                compile(fpath, html=False, print_path=False)
                r.append(fpath)
                if pos%10 == 0:
                    print pos,
    for i in r:
        compile(i, print_path=False)

    print '\nCOMPLIE PLIM DONE'


@Monitor.notify.connect
def _(filename):
    if not filename.endswith('.plim'):
        return
    compile(filename)
    compile_all(filename)



