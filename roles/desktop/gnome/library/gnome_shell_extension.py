#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2016, Eduard Angold <https://github.com/eddyhub>
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

from ansible.module_utils.basic import *
import urllib2
import json
import os.path
import zipfile
import tempfile
import ast

DOCUMENTATION = '''
---
module: gnome_shell_extension
author: Eduard Angold
short_description: install gnome-shell extensions.
description:
   - Download and install gnome shell extensions
options:
  id:
    description:
      - The id of the plugin to install.
    required: true
  gnome_version:
    description:
      - The version of gnome to get the correct plugin.
  gnome_extension_path:
    description:
      - The path where to install the plugin.
    required: true
  gnome_site:
    description:
      - The URL to the gnome shell extensions website to get the plugins.
    required: false
  status:
    description:
      - Should the plugin be enabled?
    required: false
'''

EXAMPLES = '''
# Download and install Drop Down Terminal
# https://extensions.gnome.org/extension/442/drop-down-terminal/
- gnome_shell_extension:
    id=442
    gnome_extension_path=/home/edi/.local/share/gnome-shell/extensions/
    gnome_version=3.18.3
'''


#
# Module code.
#

def _is_extension_installed(module, gnome_extension_path, extension_uuid):
    return os.path.isfile(os.path.join(gnome_extension_path, extension_uuid, "metadata.json"))

def _is_extensions_enabled(module, extension_uuid):
    return extension_uuid in set(_get_enabled_extensions_list(module))

def _get_enabled_extensions_list(module):
    enabled_extensions_str = module.run_command(' '.join(['gsettings', 'get', 'org.gnome.shell', 'enabled-extensions']))[1]
    enabled_extensions_str = enabled_extensions_str.replace('@as ', '');
    unique = set(ast.literal_eval(enabled_extensions_str))
    return list(unique)

def _set_extensions(module, extension_list):
    module.run_command(' '.join(['gsettings', 'set', 'org.gnome.shell', 'enabled-extensions', '"' + str(extension_list) + '"']))

def _enable_extension(module, extension_uuid):
    tmp_list = _get_enabled_extensions_list(module)
    tmp_list.append(str(extension_uuid))
    _set_extensions(module, tmp_list)

def _disable_extension(module, extension_uuid):
    tmp_set = set(_get_enabled_extensions_list(module))
    tmp_set.remove(str(extension_uuid))
    _set_extensions(module, list(tmp_set))

def _get_extension_info(module, id, gnome_site, gnome_version):
    try:
        info = urllib2.urlopen(gnome_site + '/extension-info/?pk=' + str(id) + '&shell_version=' + gnome_version)
        info = json.load(info)
    except Exception, e:
        module.fail_json(msg="Failure downloading metadata from %s %s" % (gnome_site, e))

    if not 'download_url' in info:
        name = info.get('name', 'Unknown')
        module.fail_json(msg="Extension '%s' (%d) is not available for version %s" % (name, id, gnome_version))

    return info

def _install_extension(module, gnome_site, gnome_extension_path, extension_url, extension_uuid):
    tmp_file = tempfile.TemporaryFile()
    download_url = gnome_site + extension_url
    try:
        tmp_file.write(urllib2.urlopen(download_url).read())
        zip_file = zipfile.ZipFile(tmp_file)
        dest_dir = os.path.join(gnome_extension_path, extension_uuid)
        if not os.path.isdir(dest_dir):
            os.makedirs(dest_dir)
        zip_file.extractall(dest_dir)
        tmp_file.close()
    except Exception, e:
        module.fail_json(msg="Failure installing the plugin %s" % e)

def _get_installed_extension_info(module, gnome_extension_path, extension_uuid):
    try:
        info = json.load(open(os.path.join(gnome_extension_path, extension_uuid, "metadata.json")))
    except Exception, e:
        module.fail_json(msg="Failure loading extension on local machine: %s" % e)
    return info

def main():
    module = AnsibleModule(
            argument_spec={
                'id': {'required': True, 'type': 'int'},
                'gnome_version': {'type': 'str'},
                'gnome_extension_path': {'required': True, 'type': 'str'},
                'gnome_site': {'type': 'str', 'default': 'https://extensions.gnome.org'},
                'status': {'default': 'enabled', 'choices': ['enabled', 'disabled']},
            },
            supports_check_mode=True
    )

    id = module.params['id']
    status = module.params['status']
    if not module.params['gnome_version']:
        gnome_version = module.run_command(" ".join(['gnome-shell', '--version']))[1].split()[-1]
    gnome_extension_path = os.path.expanduser(module.params['gnome_extension_path'])
    gnome_site = module.params['gnome_site']
    extension_info = _get_extension_info(module, id, gnome_site, gnome_version)


    old_value_is_installed = _is_extension_installed(module, gnome_extension_path, extension_info['uuid'])

    if not old_value_is_installed and not module.check_mode:
        _install_extension(module, gnome_site, gnome_extension_path, extension_info['download_url'], extension_info['uuid'])
    new_value_is_installed = _is_extension_installed(module, gnome_extension_path, extension_info['uuid'])

    old_value_is_enabled = _is_extensions_enabled(module, extension_info['uuid'])

    if not old_value_is_enabled or status == 'enabled':
        _enable_extension(module, extension_info['uuid'])
    else:
        _disable_extension(module, extension_info['uuid'])
    new_value_is_enabled = _is_extensions_enabled(module, extension_info['uuid'])
    module.exit_json(
            changed=old_value_is_installed != new_value_is_installed or old_value_is_enabled != new_value_is_enabled,
            msg=extension_info
    )

main()
