# -*- coding: utf-8 -*-
import dracula.draw

import glob
import os
import subprocess
import yaml

# Silence linter errors and enable annotation support
# pylint: disable=C0111
from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401
from qutebrowser.config.config import ConfigContainer  # noqa: F401
config = config  # type: ConfigAPI # noqa: F821 pylint: disable=E0602,C0103
c = c  # type: ConfigContainer # noqa: F821 pylint: disable=E0602,C0103

CONFIG_KEYS_DICT = (
    'aliases',
    'bindings.commands',
    'bindings.default',
    'bindings.key_mappings',
    'content.headers.custom',
    'content.javascript.log',
    'url.searchengines',
)


def read_xresources(prefix):
    props = {}
    x = subprocess.run(['xrdb', '-query'], stdout=subprocess.PIPE)
    lines = x.stdout.decode().split('\n')
    for line in filter(lambda l: l.partition('.')[0] == prefix, lines):
        prop, _, value = line.partition(':\t')
        props[prop.partition('.')[2]] = value
    return props


def dict_attrs(obj, path=''):
    if isinstance(obj, dict):
        for k, v in obj.items():
            newpath = '{}.{}'.format(path, k) if path else k
            if newpath in CONFIG_KEYS_DICT:
                yield newpath, v
            else:
                yield from dict_attrs(v, newpath)
    else:
        yield path, obj


def read_yml(filepath, xresources=None):
    with open(filepath, mode='r') as f:
        yaml_data = yaml.safe_load(f)
        for k, v in dict_attrs(yaml_data):
            if xresources and isinstance(v, str):
                v = v.format_map(xresources)
            yield k, v




xresources = read_xresources('*')

config_files = (
    fn
    for fn in glob.iglob(os.path.join(glob.escape(config.configdir), '*.yml'))
    if os.path.basename(fn) != 'autoconfig.yml'
)

config_data = {}
for filename in config_files:
    for k, v in read_yml(filename, xresources=xresources):
        if k in CONFIG_KEYS_DICT:
            if k not in config_data:
                config_data[k] = config.get(k)

            if all(isinstance(x, dict) for x in config_data[k].values()):
                v = {
                    subkey: {**config_data[k].get(subkey, {}), **subval}
                    for subkey, subval in v.items()
                }
            elif all(isinstance(x, list) for x in config_data[k].values()):
                v = {
                    subkey: config_data[k].get(subkey, []) + subval
                    for subkey, subval in v.items()
                }
            config_data[k].update(v)
        else:
            config_data[k] = v

for k, v in config_data.items():
    config.set(k, v)

dracula.draw.blood(c, {
    'spacing': {
        'vertical': 6,
        'horizontal': 8,
    }
})
