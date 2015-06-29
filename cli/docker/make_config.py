#!/usr/bin/env python
# coding: utf-8 
import getpass
import socket
import re
from mako.template import Template
from os import mkdir
from os.path import join, dirname, exists, isdir, abspath
from config import CONFIG

def make_config(filepath):
    CONFIG_DIR = abspath(join(dirname(filepath), "conf")) 
    PREFIX = dirname(dirname(dirname(CONFIG_DIR)))
    for name, outdir in (
        ('nginx.conf', "build"),
        ('fis-conf.js', "pure"),
        ('config.py', "."),
        ('config.js', "pure/lib"),
    ):
        with open(join(CONFIG_DIR, name)) as conf:
            tmpl = conf.read()

        T = Template(tmpl, 
            disable_unicode=True,
            encoding_errors='ignore',
            default_filters=['str', 'n'],
            input_encoding='utf-8',
            output_encoding='',
         )

        dirpath = join(PREFIX, outdir)
        if not exists(dirpath):
            mkdir(dirpath)
        filepath = join(dirpath, name)

        print filepath
        with open(filepath, 'w') as f:
            f.write(T.render(
                CONFIG=CONFIG,
                PREFIX=PREFIX,
            ))


make_config(__file__)

