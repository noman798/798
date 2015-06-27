#!/usr/bin/env python
#coding:utf-8

import os,sys
from pyinotify import WatchManager, Notifier, ProcessEvent, IN_DELETE, IN_CREATE, IN_MODIFY, IN_MOVED_TO
from os.path import join, dirname, isdir, abspath, basename, islink, exists, getmtime
from blinker import Signal
from dirwalk import link_path

_COMPILE_CACHE = {}

class EventHandler(ProcessEvent):
    def compress(self, event):
        path = event.path
        filename = event.pathname
        if event.dir:
            MONITOR._add_watch(filename)
        else:
            if not filename.endswith(".swp"):
                try:
                    mtime = getmtime(filename)
                except OSError:
                    mtime = 0
                if mtime and mtime != _COMPILE_CACHE.get(filename):
                    Monitor.notify.send(filename)
                    sys.stdout.flush()
                    _COMPILE_CACHE[filename] = mtime
    process_IN_CREATE = process_IN_MOVED_TO = process_IN_MODIFY = compress

class Monitor(object):

    add_watch = Signal()
    notify = Signal()

    def __init__(self):
        self.wm = WatchManager()
        self.path = []
    def run(self):
        for i in self.path:
            self.init_watch(i)
            print '开始监控 %s' % (i)
        notifier = Notifier(self.wm, EventHandler())

        while True:
            try:
                notifier.process_events()
                if notifier.check_events():
                    notifier.read_events()
            except KeyboardInterrupt:
                notifier.stop()
                break

    def _add_watch(self, path):
        mask = IN_CREATE | IN_MODIFY | IN_MOVED_TO
        self.wm.add_watch(path, mask, rec=True)

    def init_watch(self, path):
        for i in os.listdir(path):
            p = join(path, i)
            if not isdir(p):
                continue
            lp = link_path(p)
            if lp!=p:
                self._add_watch(lp)
        self._add_watch(path)

MONITOR = Monitor()

@Monitor.add_watch.connect
def _(path):
    MONITOR.path.append(path)

if __name__ == "__main__":
    pass

