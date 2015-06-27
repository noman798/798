#!/usr/bin/env python
#coding:utf-8
from os.path import join, dirname, isdir, abspath, basename, islink, exists
import os.path
from os import walk as _walk

def link_path(l):
    """
    Return an absolute path for the destination 
    of a symlink
    """
    if os.path.islink(l):
        p = os.readlink(l)
        if os.path.isabs(p):
            return p
        l = os.path.join(os.path.dirname(l), p)
    return abspath(l)
   
def walk(path):
    for (dirpath, dirnames, filenames) in _walk(path):
        yield dirpath, dirnames, filenames
        for i in dirnames:
            _path = join(dirpath,i)
            if islink(_path):
                _link_path = link_path(_path)
                for _ in _walk(_link_path):
                    _ = list(_)
                    _[0] = _[0].replace(_link_path, _path) 
                    yield tuple(_)

if __name__ == "__main__":
    pass

