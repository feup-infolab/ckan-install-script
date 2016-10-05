#!/usr/bin/env bash

su ckan
. /usr/lib/ckan/default/bin/activate
cd /usr/lib/ckan/default/src/ckan

admin_user='admin'
paster sysadmin add $admin_user -c /etc/ckan/default/development.ini
